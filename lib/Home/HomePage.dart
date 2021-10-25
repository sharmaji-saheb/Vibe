import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor/Home/HomeBloc.dart';
import 'package:minor/Home/HomeUI.dart';
import 'package:minor/Themes/Fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//Mixin for ticker provider
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //Themes and Fonts
  final ThemeFonts _fonts = ThemeFonts();

  /*
    *** BUILD***
  */
  Widget build(BuildContext context) {
    //BLOC for homepage
    final HomeBloc _bloc = HomeBloc(context);

    //Decides what to show on landing page
    final StreamController<int> _landingStreamController =
        Provider.of<StreamController<int>>(context, listen: false);

    //instance of google sign in
    final GoogleSignIn _google_sign_in =
        Provider.of<GoogleSignIn>(context, listen: false);

    //isntance of FirebaseAuth
    final FirebaseAuth _auth =
        Provider.of<FirebaseAuth>(context, listen: false);

    //UI Components of this Page
    final HomeUI _ui = HomeUI();

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff2E3036),
        appBar: _ui.appBar(context, _bloc),

        floatingActionButton: _ui.addFriend(context),

        //stack having children:-
        //container for background
        //and Padding with child column with login buttons
        body: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            String uid = snapshot.data!.getString('uid')!;

            CollectionReference collectionReference =
                FirebaseFirestore.instance.collection('friends');

            return StreamBuilder<DocumentSnapshot<Object?>>(
              stream: collectionReference.doc(uid).snapshots( ),
              builder: (context, AsyncSnapshot<DocumentSnapshot<Object?>> snap) {
                if (snap == null) {
                  print('null1');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snap.data == null) {
                  print('null2');
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                // Map<String, dynamic> data =
                //     snap.data!.data() as Map<String, dynamic>;

                Map<String, dynamic> _data =
                    snap.data!.data() as Map<String, dynamic>;
                  print(_data);

                List<String> _list = [];

                _data.keys.forEach((k) => _list.add(k));
                return Stack(
                  children: [
                    //Container for background
                    Container(
                      color: Color(0xff2E3036),
                    ),

                    _ui.friendsList(context, _list),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
