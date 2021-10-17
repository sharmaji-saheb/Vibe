import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailRegisterBloc {
  /*
  ***CONSTRUCTOR***
  */
  EmailRegisterBloc(BuildContext context) {
    _auth = Provider.of<FirebaseAuth>(context, listen: false);

    _lpass_stream = _lpass_controller.stream.transform(_lpass_transformer);

    _lemail_stream = _lemail_controller.stream.transform(_lemail_transformer);

    _login_button = Rx.combineLatest2(
      _lpass_stream,
      _lpass_stream,
      (String email, String pass) {
        if (email == '' && pass == '') {
          return true;
        } else {
          return false;
        }
      },
    );

    _landingStreamController = Provider.of<StreamController<int>>(context, listen: false);

    emailRegister = (String _email, String _pass) async {
      //signing in
      await _auth
          .createUserWithEmailAndPassword(email: _email, password: _pass)
          .then(
        (user_creds) {
          //user id
          String _uid = user_creds.user!.uid;

          //extracting possible name from email
          int _atIndex = _email.indexOf('@');
          String _name = _email.substring(0, _atIndex);

          //storing user id for accessing user data
          SharedPreferences.getInstance().then((_shared) {
            _shared.setString('uid', _uid);

            //initializing storage in firestore
            FirebaseFirestore _firestore = FirebaseFirestore.instance;
            _firestore.collection(_uid).doc('info').set(
              {
                'name': _name,
                'email': _email,
              },
            );

            //Navigating to landing page
            _landingStreamController.sink.add(2);
            FocusScope.of(context).unfocus();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }).onError((error, stackTrace) {
            showDialog(
              context: context,
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
          });
        },
      ).onError(
        (error, stackTrace) {
          showDialog(
            context: context,
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
    };
  }

  /*
  ***DECLARATION***
  */
  late final StreamController<int> _landingStreamController;
  //Build Context
  late final BuildContext context;

  //Firebase auth instance
  late final FirebaseAuth _auth;

  //Stream controller and stream for login password text field
  late StreamController<String> _lpass_controller =
      StreamController<String>.broadcast();
  late final Stream<String> _lpass_stream;

  //Stream controller and stream for login email text field
  late StreamController<String> _lemail_controller =
      StreamController<String>.broadcast();
  late final Stream<String> _lemail_stream;

  //stream transformer for error texts in login password fields
  final StreamTransformer<String, String> _lpass_transformer =
      StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) {
    if (data == '' || data == null || data.length >= 6) {
      sink.add('');
    } else {
      sink.add('Password ahould be atleast 6 characters long');
    }
  });

  //stream transformer for error texts in login email field
  final StreamTransformer<String, String> _lemail_transformer =
      StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) {
    if (data == '' ||
        data == null ||
        (data.contains('@') && data.contains('.com'))) {
      sink.add('');
    } else {
      sink.add('Enter valid Email');
    }
  });

  //Stream for login button
  late final Stream<bool> _login_button;
  /*
  ***METHODS***
  */
  late final Function(String email, String pass) emailRegister;

  /*
  ***GETTERS***
   */
  Stream<String> get lpass_stream => _lpass_stream;
  StreamSink<String> get lpass_sink => _lpass_controller.sink;

  Stream<String> get lemail_stream => _lemail_stream;
  StreamSink<String> get lemail_sink => _lemail_controller.sink;

  Stream<bool> get login_button => _login_button;
}
