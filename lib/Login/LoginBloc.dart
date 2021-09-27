import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc {
  /*
  ***CONSTRUCTOR***
  */
  LoginBloc(BuildContext context) {
    this._auth = Provider.of<FirebaseAuth>(context, listen: false);

    _phone_stream =
        _phone_stream_controller.stream.transform(_phone_transformer);

    _otp_stream = _otp_controller.stream.transform(_otp_transformer);
  }


  /*
  ***DECLARATION***
  */
  //stream controller used for error text in login page text fields
  final StreamController<String> _phone_stream_controller =
      StreamController<String>.broadcast();
  late final Stream<String> _phone_stream;

  //stream controller for
  final StreamController<bool> _page_controller = StreamController<bool>();

  //streamcontroller for otp text field
  final StreamController<String> _otp_controller = StreamController<String>.broadcast();
  late final Stream<String> _otp_stream;

  //transformer for otp text field
  //accepts the input and gives back an error message
  final StreamTransformer<String, String> _otp_transformer =
      StreamTransformer<String, String>.fromHandlers(handleData: (data, sink) {
    if (data.length == 6 || data == null || data == '') {
      sink.add('');
    } else {
      sink.add('OTP must be of 6 digits');
    }
  });

  //transformer for _phone_stream_controller
  //adds errorText in stream
  final StreamTransformer<String, String> _phone_transformer =
      StreamTransformer<String, String>.fromHandlers(
    handleData: (data, sink) {
      List<String> lst = data.split(' ');

      if ((lst[0].length > 1 && lst[1].length == 10)) {
        sink.add('');
      } else {
        sink.add('Enter Valid Number or Code');
      }
    },
  );
  
  //build context
  late final FirebaseAuth _auth;

  /*
  ***METHODS***
  */


  /*
  ***GETTERS***
   */
  Stream<String> get phone_stream => _phone_stream;
  StreamSink<String> get phone_sink => _phone_stream_controller.sink;
  Stream<bool> get page_stream => _page_controller.stream;
  Stream<String> get otp_stream => _otp_stream;
  StreamSink<String> get otp_sink => _otp_controller.sink;
}
