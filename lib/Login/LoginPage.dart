import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor/Login/LoginBloc.dart';
import 'package:minor/Themes/Fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override

  //function for onPressed of login button
  Function()? _func;

  Function()? _otp_func;

  //text field controller
  final TextEditingController _code_controller = TextEditingController();
  final TextEditingController _phone_controller = TextEditingController();
  final TextEditingController _otp_controller = TextEditingController();

  //class for fonts and theme
  final ThemeFonts _fonts = ThemeFonts();

  //focus nodes
  final FocusNode _codenode = FocusNode();
  final FocusNode _phonenode = FocusNode();

  Widget build(BuildContext context) {
    //bloc for login page
    final _bloc = LoginBloc(context);

    //instance of google sign in
    final GoogleSignIn _google_sign_in =
        Provider.of<GoogleSignIn>(context, listen: false);
    //instance of FirebaseAuth
    final FirebaseAuth _auth =
        Provider.of<FirebaseAuth>(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 10,
          backgroundColor: Color(0xff292B2F),
          title: Text(
            'Login',
            style: _fonts.scaffoldTitle(context),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          centerTitle: true,
        ),

        //stack having children:-
        //container with gesture detector for background
        //and Padding with child column with login buttons
        body: Stack(
          children: [
            //Gesture detector to detect tap on screen
            //and unfocus and close the keyboard
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                color: Color(0xff2E3036),
              ),
            ),

            //Padding with column as child for buttons
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
              ),
              child: StreamBuilder(
                stream: _bloc.page_stream,
                initialData: false,
                builder: (context, AsyncSnapshot<bool> snapshot) {
                  //returns login page to enter mobile number
                  if (snapshot.data == false) {
                    return _loginPage(context, _bloc);
                  }

                  //return otp page for otp verification
                  else {
                    return _otp(context, _bloc);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  //otp screen
  Widget _otp(BuildContext _context, LoginBloc _bloc) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //sized box for space from start
          SizedBox(
            height: MediaQuery.of(_context).size.height * 0.1,
          ),

          //text fields
          _otpTextField(_context, _bloc),

          SizedBox(
            height: 10,
          ),
          //sign in button
          _verifyButton(_context, _bloc),
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }

  //login screen
  Widget _loginPage(BuildContext _context, LoginBloc _bloc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //sized box for space from start
        SizedBox(
          height: MediaQuery.of(_context).size.height * 0.2,
        ),

        //text fields
        _mobileTextFields(_context, _bloc),

        SizedBox(
          height: 10,
        ),
        //sign in button
        _signInButton(_context, _bloc),
        Expanded(
          child: SizedBox(),
        ),
      ],
    );
  }

  //text fields to enter mobile number
  Widget _mobileTextFields(BuildContext context, LoginBloc _bloc) {
    return Container(
      child: Row(
        children: [
          //for country code
          Container(
            width: 90,
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                String data =
                    '+' + _code_controller.text + ' ' + _phone_controller.text;
                _bloc.phone_sink.add(data);
              },
              controller: _code_controller,
              focusNode: _codenode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(_phonenode);
              },
              cursorColor: Colors.white,
              style: _fonts.loginText(),
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                errorText: '',
                prefixIcon: Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                    right: 7,
                    top: 13,
                    bottom: 13,
                  ),
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                contentPadding: EdgeInsets.only(
                  right: 7,
                  left: 5,
                ),
                fillColor: Color(0xff474A51),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.all(
                    Radius.circular(7),
                  ),
                ),
              ),
            ),
          ),

          SizedBox(
            width: 10,
          ),

          //for phone number
          Expanded(
            child: StreamBuilder(
              stream: _bloc.phone_stream,
              initialData: '',
              builder: (context, AsyncSnapshot<String> snapshot) {
                return TextField(
                  onChanged: (value) {
                    String data = '+' +
                        _code_controller.text +
                        ' ' +
                        _phone_controller.text;
                    _bloc.phone_sink.add(data);
                  },
                  controller: _phone_controller,
                  focusNode: _phonenode,
                  cursorColor: Colors.white,
                  style: _fonts.loginText(),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    errorText: snapshot.data,
                    prefixIcon: Padding(
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 7,
                        top: 7,
                        bottom: 7,
                      ),
                      child: Icon(
                        Icons.phone_outlined,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                    contentPadding: EdgeInsets.only(
                      right: 7,
                      left: 5,
                    ),
                    fillColor: Color(0xff474A51),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.all(
                        Radius.circular(7),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  //sign in button
  Widget _signInButton(BuildContext context, LoginBloc _bloc) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      child: Container(
        height: 60,
        child: StreamBuilder(
          stream: _bloc.phone_stream,
          initialData: null,
          builder: (context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.data == null ||
                snapshot.data == 'Enter Valid Number or Code') {
              _func = null;
            } else {}
            return ElevatedButton(
              //redirects to Email login screen
              onPressed: _func,

              //Row for button contents
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //email logo
                  Icon(
                    Icons.login_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Login or Signup',
                          style: _fonts.loginOptionButtons(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((state) {
                return Color(0xff474A51);
              })),
            );
          },
        ),
      ),
    );
  }

  //text field for otp
  Widget _otpTextField(BuildContext _context, LoginBloc _bloc) {
    return Container(
      width: 200,
      child: StreamBuilder(
        stream: _bloc.otp_stream,
        initialData: '',
        builder: (context, AsyncSnapshot<String> snapshot) {
          return TextField(
            maxLength: 6,
            onChanged: (value){
              _bloc.otp_sink.add(value);
            },
            cursorColor: Colors.white,
            style: _fonts.loginText(),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              errorText: snapshot.data,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  left: 10,
                  right: 7,
                  top: 13,
                  bottom: 13,
                ),
                child: Icon(
                  Icons.password_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              contentPadding: EdgeInsets.only(
                right: 7,
                left: 5,
              ),
              fillColor: Color(0xff474A51),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(
                  Radius.circular(7),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  //otp submit button
  Widget _verifyButton(BuildContext _context, LoginBloc _bloc) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      child: Container(
        height: 60,
        width: 100,
        child: StreamBuilder(
          stream: _bloc.otp_stream,
          initialData: null,
          builder: (context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.data == null ||
                snapshot.data == 'Enter Valid Number or Code') {
              _otp_func = null;
            } else {}
            return ElevatedButton(
              //redirects to Email login screen
              onPressed: _otp_func,
              child: Text(
                'Verify',
                style: _fonts.loginOptionButtons(),
              ),

              style: ButtonStyle(backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((state) {
                return Color(0xff474A51);
              })),
            );
          },
        ),
      ),
    );
  }
}
