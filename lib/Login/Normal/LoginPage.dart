import 'package:flutter/material.dart';
import 'package:minor/Login/Special/SpecialLogin.dart';
import 'package:minor/Themes/Fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginUIComponents.dart';
import 'LoginBloc.dart';

class LoginPage extends StatelessWidget {
  //class for fonts and theme
  final ThemeFonts _fonts = ThemeFonts();

  //contains ui components
  final LoginUIComponents _components = LoginUIComponents();

  Widget build(BuildContext context) {
    //bloc for login page
    final _bloc = LoginBloc(context);

    //checking mode
    if(Provider.of<String>(context, listen: false) == 'special'){
      //If special mode returning special login interface
      return SpecialLogin();
    }

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
          onTap: _bloc.changeMode,
          child: Icon(
            Icons.vibration_outlined,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 25,
        ),
          ],
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //sized box for space from start
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),

                  //google signin button
                  _components.loginPageButton(
                      _bloc.googleSignIn,
                      0xff383D6C,
                      _fonts.loginOptionButtons(),
                      Image.asset(
                        'images/google_logo.png',
                        height: 40,
                        width: 40,
                      ),
                      'Sign In with Google'),

                  SizedBox(
                    height: 10,
                  ),
                  //email sign in button
                  _components.loginPageButton(() {
                    Navigator.of(context).pushNamed('/EmailLogin');
                  },
                      0xff474A51,
                      _fonts.loginOptionButtons(),
                      Icon(
                        Icons.email_outlined,
                        color: Colors.white,
                        size: 40,
                      ),
                      'Sign In with E-Mail'),
                  Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
