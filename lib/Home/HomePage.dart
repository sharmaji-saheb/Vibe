import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  String a = '';

  Widget build(BuildContext context) {
    final StreamController<int> _landingStreamController =
        Provider.of<StreamController<int>>(context, listen: false);
    //instance of google sign in
    final GoogleSignIn _google_sign_in =
        Provider.of<GoogleSignIn>(context, listen: false);
    //isntance of FirebaseAuth
    final FirebaseAuth _auth =
        Provider.of<FirebaseAuth>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff2E3036),
        appBar: AppBar(
          actions: [
            TextButton.icon(
              onPressed: () async {
                if (await _google_sign_in.isSignedIn()) {
                  await _google_sign_in.disconnect();
                  await _auth.signOut().then((value) async {
                    _landingStreamController.sink.add(1);
                    SharedPreferences _shared =
                        await SharedPreferences.getInstance();
                    _shared.remove('uid');
                  });
                } else {
                  _auth.signOut().then((value) async {
                    _landingStreamController.sink.add(1);
                    SharedPreferences _shared =
                        await SharedPreferences.getInstance();
                    _shared.remove('uid');
                  });
                }
              },
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              label: Text('logout'),
            )
          ],
          elevation: 0,
          backgroundColor: Color(0xff292B2F),
          title: Text(
            'Minor',
            style: _fonts.scaffoldTitle(context),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.13,
        ),

        //stack having children:-
        //container for background
        //and Padding with child column with login buttons
        body: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
            if (snapshot.data == null) {
              return CircularProgressIndicator();
            }

            String uid = snapshot.data!.getString('uid')!;
            print('uid is ${uid}');

            CollectionReference collectionReference =
                FirebaseFirestore.instance.collection(uid);

            return FutureBuilder<DocumentSnapshot>(
              future: collectionReference.doc('info').get(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
                if (snap == null) {
                  print('null1');
                  return CircularProgressIndicator();
                }
                if (snap.data == null) {
                  print('null2');
                  return CircularProgressIndicator();
                }
                // Map<String, dynamic> data =
                //     snap.data!.data() as Map<String, dynamic>;
                Map<String, dynamic> _data =
                    snap.data!.data() as Map<String, dynamic>;

                return Stack(
                  children: [
                    //Container for background
                    Container(
                      color: Color(0xff2E3036),
                    ),

                    //TabView
                    Container(
                      child: Text(
                        _data.toString(),
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
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

//Logout metthod
// () async {
//               if (await _google.isSignedIn()) {
//                 await _google.disconnect();
//                 await _auth.signOut();
//               }else{
//                 _auth.signOut();
//               }
//             },
