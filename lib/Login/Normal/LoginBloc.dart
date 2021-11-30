import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  /*
  ***CONSTRUCTOR***
  */
  LoginBloc(BuildContext context) {
    _google = Provider.of<GoogleSignIn>(context, listen: false);

    _auth = Provider.of<FirebaseAuth>(context, listen: false);

    _landingStreamController = Provider.of<StreamController<int>>(context, listen: false);

    _context = context;
  }

  /*
  ***DECLARATION***
  */
  //StreamController to communicate with landing page
  late final StreamController<int> _landingStreamController;
  //Build Context
  late final BuildContext _context;

  //Firebase auth instance
  late final FirebaseAuth _auth;

  //GoogleSignIn instance
  late final GoogleSignIn _google;

  /*
  ***METHODS***
  */
  changeMode() {
    showDialog(
      context: _context,
      builder: (_context) {
        return AlertDialog(
          title: Text('change mode'),
          content: Text(
              'Are you sure you want to change to special mode?\nIf yes press ok'),
          actions: [
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                SharedPreferences.getInstance().then((value) {
                  value.setString('mode', 'special');
                }).then((value) {
                  Navigator.pop(_context);
                  showDialog(
                    context: _context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text('restart the app for changes to apply'),
                      );
                    },
                  );
                });
              },
            ),

            TextButton(
              onPressed: (){
                Navigator.pop(_context);
              },
              child: Text('cancel'),
            )
          ],
        );
      },
    );
  }
  
  googleSignIn() async {
    GoogleSignInAccount? acc = await _google.signIn();
    if (acc == null) return;
    GoogleSignInAuthentication googleAuth = await acc.authentication;
    OAuthCredential creds = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    _auth.signInWithCredential(creds).then((user_creds) async {
      //storing uid for future and accessing user information
      String _uid = user_creds.user!.uid;
      SharedPreferences shared = await SharedPreferences.getInstance();
      String _name = user_creds.user!.displayName!;
      String _email = user_creds.user!.email!;
      shared.setString('uid', _uid);
      shared.setString('name', _name);
      shared.setString('email', _email);

      FirebaseFirestore.instance.collection('info').doc(_uid).get().then((doc) {
        //if user signed in first time
        //then creating new firestore documents
        if (!doc.exists) {
          //initializing storage in firestore
          FirebaseFirestore _firestore = FirebaseFirestore.instance;
          _firestore.collection('info').doc(_uid).set(
            {
              'name': _name,
              'email': _email,
            },
          );

          _firestore.collection('publicInfo').doc(_uid).set(
            {
              'name': _name,
              'email': _email,
            },
          );
        }
        _landingStreamController.sink.add(2);
      });
    });
  }

  /*
  ***GETTERS***
   */
}
