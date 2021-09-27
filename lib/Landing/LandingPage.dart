import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minor/Home/HomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:minor/Login/LoginPage.dart';
import 'package:provider/provider.dart';

/*  
  LANDING PAGE.

  If user is signed in, it shows HomePage.
  If user is not signed in, it shows the login page
*/
class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  Widget build(BuildContext context) {
    //FutureBuilder to make sure to intialize Firebase

    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else if (snapshot.data == null) {
          return CircularProgressIndicator();
        } else {
          //StreamBuilder with stream for authentication status changes.
          //It decides whether to show Login page or Home page

          return StreamBuilder(
            stream: Provider.of<FirebaseAuth>(context, listen: false)
                .authStateChanges(),
            builder: (context, AsyncSnapshot<User?> snap) {
              if (!snap.hasData || snap.data == null) {
                //returns Login Page
                return LoginPage();
              } else {
                return HomePage();
              }
            },
          );
        }
      },
    );
  }
}
