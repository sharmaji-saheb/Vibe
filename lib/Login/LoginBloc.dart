import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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
  }

  /*
  ***DECLARATION***
  */
  //StreamController to communicate with landing page
  late final StreamController<int> _landingStreamController;
  //Build Context
  late final BuildContext context;

  //Firebase auth instance
  late final FirebaseAuth _auth;

  //GoogleSignIn instance
  late final GoogleSignIn _google;

  /*
  ***METHODS***
  */
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
      shared.setString('uid', _uid);

      String _name = user_creds.user!.displayName!;
      String _email = user_creds.user!.email!;

      print('\n\n\n\n\n\n\n${_name} ${_email}\n\n\n\n\n\n');

      FirebaseFirestore.instance.collection(_uid).doc('info').get().then((doc) {
        //if user signed in first time
        //and hence have no data in firestore
        if (!doc.exists) {
          //initializing storage in firestore
          FirebaseFirestore _firestore = FirebaseFirestore.instance;
          _firestore.collection(_uid).doc('info').set(
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
