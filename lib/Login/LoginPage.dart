import 'package:flutter/material.dart';
import 'package:minor/Login/LoginBloc.dart';
import 'package:minor/Themes/Fonts.dart';

class LoginPage extends StatelessWidget {
 
  //class for fonts and theme
  final ThemeFonts _fonts = ThemeFonts();

  Widget build(BuildContext context) {
    //bloc for login page
    final _bloc = LoginBloc(context);

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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //sized box for space from start
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),

                  //text fields
                  _googleSignIn(context, _bloc),

                  SizedBox(
                    height: 10,
                  ),
                  //sign in button
                  _emailSignIn(context, _bloc),
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

  //text fields to enter mobile number
  Widget _googleSignIn(BuildContext context, LoginBloc _bloc) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      child: Container(
        height: 60,
        child: ElevatedButton(
          //redirects to Email login screen
          onPressed: _bloc.googleSignIn,

          //Row for button contents
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //email logo
              Image.asset('images/google_logo.png', height: 40, width: 40,),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In with Google',
                      style: _fonts.loginOptionButtons(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>((state) {
            return Color(0xff383D6C);
          })),
        ),
      ),
    );
  }

  //sign in button
  Widget _emailSignIn(BuildContext context, LoginBloc _bloc) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      child: Container(
        height: 60,
        child: ElevatedButton(
          //redirects to Email login screen
          onPressed: (){
            Navigator.of(context).pushNamed('/EmailLogin');
          },

          //Row for button contents
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //email logo
              Icon(
                Icons.email_outlined,
                color: Colors.white,
                size: 40,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Sign In with E-Mail',
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
        ),
      ),
    );
  }
}
