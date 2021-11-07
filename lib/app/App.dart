import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor/Routes/RouteGenerator.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Provider
    return MultiProvider(
      providers: [
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
