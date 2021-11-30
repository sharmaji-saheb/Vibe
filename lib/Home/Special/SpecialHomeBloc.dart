import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class SpecialHomeBloc {
  /*
    *** CONSTRUCTOR ***
  */
  SpecialHomeBloc(BuildContext _context) {
    _states = StreamController<int>.broadcast();
    _active = Provider.of<StreamController<bool>>(_context, listen: false);
    _page = StreamController<String>.broadcast();
    _chat = StreamController<int>.broadcast();
    _pagecontroll = StreamController<bool>.broadcast();
    _google_sign_in = Provider.of<GoogleSignIn>(_context, listen: false);
    _auth = Provider.of<FirebaseAuth>(_context, listen: false);
    _landingStreamController =
        Provider.of<StreamController<int>>(_context, listen: false);
    _addpage = StreamController<int>.broadcast();
    _addPagecontroll = StreamController<bool>.broadcast();
  }

  /*
    *** DECLARATIONS ***
  */
  late final StreamController<int> _states;
  late final StreamController<bool> _active;
  late final StreamController<bool> _pagecontroll;
  late final StreamController<String> _page;
  late final StreamController<int> _chat;
  late final FirebaseAuth _auth;
  late final StreamController<int> _landingStreamController;
  late final GoogleSignIn _google_sign_in;
  late final StreamController<int> _addpage;
  late final StreamController<bool> _addPagecontroll;
  final Vibes _vibes = Vibes();

  /*
    *** METHODS ***
  */
  signOut() async {
    print('signout');
    activeSink.add(false);
    if (await _google_sign_in.isSignedIn()) {
      _google_sign_in.disconnect().then((value) {
        _auth.signOut().then((v) {
          _landingStreamController.sink.add(1);
          SharedPreferences.getInstance().then((_shared) {
            _shared.remove('uid');
            _shared.remove('name');
            _shared.remove('email');
            pageSink.add('main');
            Vibration.vibrate(duration: 1500);
            Future.delayed(Duration(milliseconds: 1500)).then((value) {
              activeSink.add(true);
            });
          });
        });
      });
    } else {
      _auth.signOut().then((value) {
        _landingStreamController.sink.add(1);
        SharedPreferences.getInstance().then((_shared) {
          _shared.remove('uid');
          _shared.remove('name');
          _shared.remove('email');
          pageSink.add('main');
          Vibration.vibrate(duration: 1500);
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            activeSink.add(true);
          });
        });
      });
    }
  }

  addFriend(String _otherEmail, String _otherName) {
    print('pressed ' + _otherName + '' + _otherEmail);
    SharedPreferences.getInstance().then((value) {
      String? _email = value.getString('email');
      String? _name = value.getString('name');
      print(_email! + ' ' + _name!);
      if (_email == _otherEmail) {
        print('equal');
        _vibes.wrongVibe().then((value) {
          activeSink.add(true);
        });
      } else {
        FirebaseFirestore.instance
            .collection('chatRooms')
            .doc('${_email}&&${_otherEmail}')
            .get()
            .then((value) {
              print(value.exists);
          if (!value.exists) {
            print('exist1');
            FirebaseFirestore.instance
                .collection('chatRooms')
                .doc('${_otherEmail}&&${_email}')
                .get()
                .then((value) {
                  print(value.exists);
              if (value.exists) {
                print('exist2');
                _vibes.wrongVibe().then((value) {
                  activeSink.add(true);
                });
              }
              if (!value.exists) {
                print('dont exist');
                FirebaseFirestore.instance
                    .collection('chatRooms')
                    .doc('${_email}&&${_otherEmail}')
                    .set({
                  'email': [_email, _otherEmail],
                  'names': {'${_email}': _name, '${_otherEmail}': _otherName},
                  'index': 0,
                  'latestTime': 0,
                  'seen': {'${_email}': 0, '${_otherEmail}': 0},
                }).then((value) {
                  FirebaseFirestore.instance
                      .collection('chatRooms')
                      .doc('${_email}&&${_otherEmail}')
                      .collection('messages')
                      .doc('messages')
                      .set({}).then((value) {
                    print('set');
                    Vibration.vibrate(duration: 1500);
                    pageSink.add('main');
                    statesSink.add(0);
                    Future.delayed(Duration(milliseconds: 1500)).then((value) {
                      print('done');
                      activeSink.add(true);
                    });
                  });
                });
              }
            });
          } else {
            _vibes.wrongVibe().then((value) {
              activeSink.add(true);
            });
          }
        });
      }
    });
  }

  /*
    *** GETTERS ***
  */
  Stream<bool> get addPageControll => _addPagecontroll.stream;
  Stream<int> get states => _states.stream;
  Stream<bool> get active => _active.stream;
  Stream<bool> get pageControll => _pagecontroll.stream;
  Stream<String> get page => _page.stream;
  Stream<int> get chat => _chat.stream;
  Stream<int> get addPage => _addpage.stream;

  Sink<bool> get addPageContSink => _addPagecontroll.sink;
  Sink<int> get statesSink => _states.sink;
  Sink<bool> get activeSink => _active.sink;
  Sink<bool> get pageControllSink => _pagecontroll.sink;
  Sink<String> get pageSink => _page.sink;
  Sink<int> get chatSink => _chat.sink;
  Sink<int> get addPageSink => _addpage.sink;
}
