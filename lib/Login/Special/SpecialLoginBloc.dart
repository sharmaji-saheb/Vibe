import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minor/Login/Normal/EmailLoginBloc.dart';
import 'package:minor/Login/Normal/LoginBloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class SpecialLoginBloc {
  /*
    *** CONSTRUCTOR ***
  */
  SpecialLoginBloc(BuildContext _context) {
    _tap = StreamController<int>.broadcast();
    _landingStreamController =
        Provider.of<StreamController<int>>(_context, listen: false);
    _auth = Provider.of<FirebaseAuth>(_context, listen: false);
    _bloc = LoginBloc(_context);
    _textField = StreamController<bool>.broadcast();
    _select = StreamController<int>.broadcast();
    _active = Provider.of<StreamController<bool>>(_context, listen: false);
    _emailLoginBloc = EmailLoginBloc(_context);
    emailSignIn = (String email, String pass) async {
      _auth
          .signInWithEmailAndPassword(email: email, password: pass)
          .then((user_creds) async {
        //storing uid for future and accessing user information
        SharedPreferences shared = await SharedPreferences.getInstance();
        shared.setString('uid', user_creds.user!.uid);
        DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
            .instance
            .collection('info')
            .doc(user_creds.user!.uid)
            .get();
        String name = doc.data()!['name'];
        String email = doc.data()!['email'];
        shared.setString('email', email);
        shared.setString('name', name);
        //Navigating to Landing Page
        _landingStreamController.sink.add(2);
        FocusScope.of(_context).unfocus();
        Navigator.of(_context).pop();
        activeSink.add(false);
        Vibration.vibrate(duration: 1500);
        Future.delayed(Duration(milliseconds: 1500)).then((value) {
          activeSink.add(true);
        });
      }).onError((error, stackTrace) async {
        if (error.toString() ==
            "[firebase_auth/user-not-found] There is no user record corresponding to this identifier. The user may have been deleted") {
          await _auth
              .createUserWithEmailAndPassword(email: email, password: pass)
              .then(
            (user_creds) {
              //user id
              String _uid = user_creds.user!.uid;

              //extracting possible name from email
              int _atIndex = email.indexOf('@');
              String _name = email.substring(0, _atIndex);

              //storing user id for accessing user data
              SharedPreferences.getInstance().then((_shared) {
                _shared.setString('uid', _uid);
                _shared.setString('name', _name);
                _shared.setString('email', email);

                //initializing storage in firestore
                FirebaseFirestore _firestore = FirebaseFirestore.instance;
                _firestore.collection('publicInfo').doc(_uid).set(
                  {
                    'name': _name,
                    'email': email,
                  },
                );

                _firestore.collection('info').doc(_uid).set(
                  {
                    'name': _name,
                    'email': email,
                  },
                );

                //Navigating to landing page
                _landingStreamController.sink.add(2);
                FocusScope.of(_context).unfocus();
                Navigator.of(_context).pop();
                activeSink.add(false);
                Vibration.vibrate(duration: 1500);
                Future.delayed(Duration(milliseconds: 1500)).then((value) {
                  activeSink.add(true);
                });
              });
            },
          ).onError(
            (error, stackTrace) {
              showDialog(
                context: _context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('error'),
                    content: Text(error.toString()),
                    actions: [
                      TextButton(
                        child: Text('ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                },
              );
            },
          );
        }
      });
    };
  }

  /*
    *** DECLARATIONS ***
  */
  late final FirebaseAuth _auth;
  late final LoginBloc _bloc;
  late final EmailLoginBloc _emailLoginBloc;
  late final StreamController<bool> _textField;
  late final StreamController<int> _select;
  late final StreamController<bool> _active;
  late final StreamController<int> _landingStreamController;
  late final Function(String email, String pass) emailSignIn;
  late final StreamController<int> _tap;

  /*
    *** METHODS ***
  */
  void gooogleSignIn() {
    _bloc.googleSignIn();
  }

  /*
    *** GETTERS ***
  */

  Stream<bool> get isInTextField => _textField.stream;
  Sink<bool> get isInTextSink => _textField.sink;

  Stream<int> get select => _select.stream;
  Sink<int> get selectSink => _select.sink;

  Stream<bool> get active => _active.stream;
  Sink<bool> get activeSink => _active.sink;

  Stream<int> get tap => _tap.stream;
  Sink<int> get tapSink => _tap.sink;
}
