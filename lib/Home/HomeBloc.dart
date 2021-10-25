import 'dart:async';
import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor/DB/Db.dart';
import 'package:minor/DB/DbNames.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBloc {
  CollectionReference reference =
      FirebaseFirestore.instance.collection('collectionPath');
  /*
    ***CONSTRUCTOR***
  */
  HomeBloc(BuildContext cont) {
    _db = DbProvider();
    _dbNames = DbNames();
    _context = cont;
    _google_sign_in = Provider.of<GoogleSignIn>(_context, listen: false);
    _auth = Provider.of<FirebaseAuth>(_context, listen: false);
    _landingStreamController =
        Provider.of<StreamController<int>>(_context, listen: false);
    SharedPreferences.getInstance().then(
      (value) {
        _uid = value.getString('uid');
        _friendsList = FirebaseFirestore.instance
            .collection('friends')
            .doc(_uid)
            .snapshots();
        _subscription = _friendsList.listen(
          (event) {
            Map<String, dynamic>? _data = event.data();
            Map<String, dynamic> data = SplayTreeMap.from(
              _data!,
              (key1, key2) => _data[key1].compareTo(_data[key2]),
            );
            print(data);
          },
        );
      },
    );
  }
  

  /*
    ***DECLARATIONS***
  */
  late final BuildContext _context;
  late final GoogleSignIn _google_sign_in;
  late final FirebaseAuth _auth;
  late final StreamController<int> _landingStreamController;
  late final DbProvider _db;
  late final DbNames _dbNames;
  late final Stream<DocumentSnapshot<Map<String, dynamic>>> _friendsList;
  late final String? _uid;
  late final StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      _subscription;

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
      });
    }

    DbProvider db = DbProvider();
    DbNames _dbnames = DbNames();
  }
}
