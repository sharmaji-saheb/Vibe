import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minor/Login/Special/SpecialEmailLogin.dart';
import 'package:minor/Themes/Fonts.dart';
import 'package:provider/provider.dart';
import 'EmailLoginBloc.dart';
import 'LoginUIComponents.dart';

class EmailLogin extends StatefulWidget {
  const EmailLogin({Key? key}) : super(key: key);

  @override
  _EmailLoginState createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLogin> {
  //Controllors for TextFields
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  //Instance of ThemeFonts class of Fonts and Themes
  final _fonts = ThemeFonts();

  //ui components
  LoginUIComponents _components = LoginUIComponents();

  late final UserCredential _userCred;

  //Focus nodes for text fields
  final FocusNode _passnode = FocusNode();
  final FocusNode _emailnode = FocusNode();

  /*
  ***BUILD FUNCTION***
  */
  Widget build(BuildContext context) {
    //Instance of Login Bloc
    final EmailLoginBloc _bloc = EmailLoginBloc(context);

    //checking mode
    if(Provider.of<String>(context, listen: false) == 'special'){
      //if special mode returning special email login interface
      return SpecialEmailLogin();
    }

    //normal widgets for email login
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 10,

          //Gesture Detector for navigating back
          leading: GestureDetector(
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
            onTap: () async {
              FocusScope.of(context).unfocus();
              await Future.delayed(Duration(milliseconds: 50));
              Navigator.of(context).pop();
            },
          ),

          //one action Gesture Detector for navigating to Registration Page
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/EmailLogin/EmailRegister');
                },
                child: Icon(
                  Icons.person_add_alt_outlined,
                  color: Colors.white,
                  size: 35,
                ),
              ),
            ),
          ],
          backgroundColor: Color(0xff292B2F),
          title: Text(
            'Login',
            style: _fonts.scaffoldTitle(context),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          centerTitle: true,
        ),
        body: Stack(
          //stack with children
          //a gesture detector
          //and a container
          children: [
            //gesture detector all over screen to unfocus keyboard after tap on screen
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: Container(
                color: Color(0xff2E3036),
              ),
            ),

            //Container with all fields and a button
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),

              //Column with Fields and Button
              child: Column(
                children: [
                  //SizedBox to leave some space from start
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.08,
                  ),

                  //Email text field
                  _components.loginTextFields(
                    _bloc,
                    () {
                      FocusScope.of(context).requestFocus(_passnode);
                    },
                    (value) {
                      _bloc.lemail_sink.add(value);
                    },
                    _bloc.lemail_stream,
                    _emailnode,
                    _email,
                    _fonts.loginText(),
                    Icon(
                      Icons.email_outlined,
                      color: Colors.white,
                      size: 42,
                    ),
                    false,
                    TextInputType.emailAddress,
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  //password text field
                  _components.loginTextFields(
                    _bloc,
                    () {
                      FocusScope.of(context).requestFocus(_passnode);
                    },
                    (value) {
                      _bloc.lpass_sink.add(value);
                    },
                    _bloc.lpass_stream,
                    _passnode,
                    _pass,
                    _fonts.loginText(),
                    Icon(
                      Icons.vpn_key_outlined,
                      color: Colors.white,
                      size: 42,
                    ),
                    true,
                    TextInputType.text,
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  //Login Button
                  _components.loginButton(
                    context,
                    _bloc,
                    () {
                      _bloc.emailSignIn(_email.text, _pass.text);
                    },
                    _email,
                    _pass,
                    'Login',
                  ),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
