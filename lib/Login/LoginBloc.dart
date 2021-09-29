import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginBloc {
  /*
  ***CONSTRUCTOR***
  */
  LoginBloc(BuildContext context) {
    _google = Provider.of<GoogleSignIn>(context, listen: false);

    _auth = Provider.of<FirebaseAuth>(context, listen: false);

  }

  /*
  ***DECLARATION***
  */
  //Build Context
  late final BuildContext context;

  //Firebase auth instance
  late final FirebaseAuth _auth;

  //GoogleSignIn instance
  late final GoogleSignIn _google;

  
  /*
  ***METHODS***
  */
  googleSignIn() async {
    GoogleSignInAccount? acc = await _google.signIn();
    if (acc == null) return;
    GoogleSignInAuthentication googleAuth = await acc.authentication;
    OAuthCredential creds = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential user_creds = await _auth.signInWithCredential(creds);
  }

  /*
  ***GETTERS***
   */
}
