import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginBloc {
  /*
  ***CONSTRUCTOR***
  */
  LoginBloc(BuildContext context) {
    _google = Provider.of<GoogleSignIn>(context, listen: false);

    _auth = Provider.of<FirebaseAuth>(context, listen: false);

    _lpass_stream = _lpass_controller.stream.transform(_lpass_transformer);

    _lemail_stream = _lemail_controller.stream.transform(_lemail_transformer);
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

  //Stream controller and stream for login password text field
  late StreamController<String> _lpass_controller = StreamController<String>.broadcast();
  late final Stream<String> _lpass_stream;

  //Stream controller and stream for login email text field
  late StreamController<String> _lemail_controller = StreamController<String>.broadcast();
  late final Stream<String> _lemail_stream;

  //stream transformer for error texts in login password fields
  final StreamTransformer<String, String> _lpass_transformer = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink){
      if(data == '' || data == null || data.length >= 6){
        sink.add('');
      }else{
        sink.add('Password ahould be atleast 6 characters long');
      }
    }
  );

  //stream transformer for error texts in login email field
  final StreamTransformer<String, String> _lemail_transformer = StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink){
      if(data == '' || data == null || (data.contains('@') && data.contains('.com'))){
        sink.add('');
      }else{
        sink.add('Enter valid Email');
      }
    }
  );

  Rx.combineLatest2(streamA, streamB, (a, b) => (a, b){
    if(a == '')
  })

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
  Stream<String> get lpass_stream => _lpass_stream;
  StreamSink<String> get lpass_sink => _lpass_controller.sink;

  Stream<String> get lemail_stream => _lemail_stream;
  StreamSink<String> get lemail_sink => _lemail_controller.sink;
}
