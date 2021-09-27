import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor/Routes/RouteGenerator.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

        //google signin provider
        Provider<GoogleSignIn>(
          create: _googleSignIn,
        ),

        Provider<Future<SharedPreferences>>(
          create: _shared,
        )
      ],
      child: MaterialApp(
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }

  Future<SharedPreferences> _shared(BuildContext context) async {
    return await SharedPreferences.getInstance();
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
}
