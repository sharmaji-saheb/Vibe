import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc {
  CollectionReference reference =
      FirebaseFirestore.instance.collection('collectionPath');
  /*
    ***CONSTRUCTOR***
  */
  HomeBloc(BuildContext cont) {
    _context = cont;
    _google_sign_in = Provider.of<GoogleSignIn>(_context, listen: false);
    _auth = Provider.of<FirebaseAuth>(_context, listen: false);
    _landingStreamController =
        Provider.of<StreamController<int>>(_context, listen: false);
    SharedPreferences.getInstance().then((value) {
      _uid = value.getString('uid');
    });
  }

  /*
    ***DECLARATIONS***
  */
  late final BuildContext _context;
  late final GoogleSignIn _google_sign_in;
  late final FirebaseAuth _auth;
  //landing stream for landing page state management
  late final StreamController<int> _landingStreamController;
  late final String? _uid;
  final StreamController<String> _search = StreamController<String>.broadcast();

  /*
    ***METHODS***
  */

  signOut() async {
    if (await _google_sign_in.isSignedIn()) {
      await _google_sign_in.disconnect();
      await _auth.signOut().then((value) async {
        _landingStreamController.sink.add(1);
        SharedPreferences _shared = await SharedPreferences.getInstance();
        _shared.remove('uid');
      });
    } else {
      _auth.signOut().then((value) async {
        _landingStreamController.sink.add(1);
        SharedPreferences _shared = await SharedPreferences.getInstance();
        _shared.remove('uid');
        _shared.remove('name');
        _shared.remove('email');
      });
    }
  }

  //adding new friend, ie chatroom for new chat
  addFriend(String _otherEmail, String _otherName) {
    print('pressed');
    SharedPreferences.getInstance().then((value) {
      String? _email = value.getString('email');
      String? _name = value.getString('name');
      FirebaseFirestore.instance
          .collection('chatRooms')
          .doc('${_email}&&${_otherEmail}')
          .get()
          .then((value) {
        if (!value.exists) {
          FirebaseFirestore.instance
              .collection('chatRooms')
              .doc('${_otherEmail}&&${_email}')
              .get()
              .then((value) {
            if (!value.exists) {
              FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc('${_email}&&${_otherEmail}')
                  .set({
                'email': [_email, _otherEmail],
                'names': {'${_email}': _name, '${_otherEmail}': _otherName},
                'index': 0,
                'latestTime': 0
              }).then((value){
                FirebaseFirestore.instance
                .collection('chatRooms')
                .doc('${_email}&&${_otherEmail}')
                .collection('messages')
                .doc('messages')
                .set({});
              });
            }
          });
        }
      });
    });
  }

  /*
    ***GETTERS***
  */
  Stream<String> get searchStream => _search.stream;
  Sink<String> get searchSink => _search.sink;
}
