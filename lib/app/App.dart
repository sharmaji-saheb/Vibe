import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor/Routes/RouteGenerator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class App extends StatelessWidget {
  String _mode = '';

  @override
  Widget build(BuildContext context) {
    //getting sharedpreferences for getting mode
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, AsyncSnapshot<SharedPreferences> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            color: Color(0xff2E3036),
          );
        }
        if (snapshot.data == null) {
          return Container(
            color: Color(0xff2E3036),
          );
        }

        _mode = snapshot.data!.getString('mode')!;

        if (_mode == 'special') {
          Vibration.vibrate(duration: 1500);
        }

        //Provider
        return MultiProvider(
          providers: [
            //Saves Mode
            Provider<String>(
              create: _getMode,
            ),

            //authentication provider
            Provider<FirebaseAuth>(
              create: _auth,
            ),

            //google sign in
            Provider<GoogleSignIn>(
              create: _googleSignIn,
            ),

            //Stream controlling landing page
            Provider<StreamController<int>>(
              create: _landingStatusStream,
            ),
          ],
          child: MaterialApp(
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
          ),
        );
      },
    );
  }

  String _getMode(BuildContext context) {
    return 'normal';
  }

  FirebaseAuth _auth(BuildContext context) {
    return FirebaseAuth.instance;
  }

  GoogleSignIn _googleSignIn(BuildContext context) {
    return GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/drive',
      ],
    );
  }

  StreamController<int> _landingStatusStream(BuildContext context) {
    return StreamController<int>();
  }
}
