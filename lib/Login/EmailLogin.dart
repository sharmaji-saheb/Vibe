import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minor/Login/LoginBloc.dart';
import 'package:minor/Themes/Fonts.dart';
import 'package:provider/provider.dart';

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
  late final UserCredential _userCred;

  //These booleans decide whether to activate login button or not
  bool _s1 = false;
  bool _s2 = false;

  //onpressed function for login button
  Function()? _loginButtonOnPressed = null;

  //Focus nodes for text fields
  final FocusNode _passnode = FocusNode();
  final FocusNode _emailnode = FocusNode();

  Widget build(BuildContext context) {
    //Instance of Login Bloc
    final LoginBloc _bloc = LoginBloc(context);

    //instance of Firebaseauth from Provider
    final FirebaseAuth _auth =
        Provider.of<FirebaseAuth>(context, listen: false);

    //All Widgets
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
                  _emailText(context, _bloc),
                  SizedBox(
                    height: 10,
                  ),

                  //password text field
                  _passText(context, _bloc),
                  SizedBox(
                    height: 10,
                  ),

                  //Login Button
                  _loginButton(_auth),
                  Expanded(child: SizedBox())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Login button Field
  Widget _loginButton(FirebaseAuth _auth) {
    //ClipRRect for Rounded Border
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(7)),
      child: Container(
        height: 50,
        child: ElevatedButton(
          //_loginButtonOnPressed is login Function()?
          onPressed: _loginButtonOnPressed,
          child: Text(
            'Login',
            style: _fonts.loginButton(35),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (state) {
                return Color(0xff383D6C);
              },
            ),
          ),
        ),
      ),
    );
  }

  //Password Text Field
  Widget _passText(BuildContext context, LoginBloc _bloc) {
    return StreamBuilder(
      stream: _bloc.lpass_stream,
      initialData: '',
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          focusNode: _passnode,

          //setting state on changes to set error text
          onChanged: (value) {
            _bloc.lpass_sink.add(value);
          },
          controller: _pass,
          obscureText: true,
          cursorColor: Colors.white,
          style: _fonts.loginText(),
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
                Icons.vpn_key_outlined,
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
    );
  }

  //Email text Field
  Widget _emailText(BuildContext context, LoginBloc _bloc) {
    return StreamBuilder(
      stream: _bloc.lemail_stream,
      initialData: '',
      builder: (context, AsyncSnapshot<String> snapshot) {
    return TextField(
      autofocus: true,
      focusNode: _emailnode,

      //Functionality of on editing complete button
      onEditingComplete: () {
        FocusScope.of(context).requestFocus(_passnode);
      },

      //setting state on changes to set error text
      onChanged: (value) {
        _bloc.lemail_sink.add(value);
      },
      controller: _email,
      cursorColor: Colors.white,
      style: _fonts.loginText(),
      keyboardType: TextInputType.emailAddress,
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
            Icons.email_outlined,
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
    );},);
  }

  //pop function to navigate back after succeful login
  _pop(value) async {
    //Unfocus is implemented to close keyboard and after 50 ms
    //pop function is implemented.
    //delay is to make sure that keyboard is closed
    FocusScope.of(context).unfocus();
    await Future.delayed(Duration(milliseconds: 50));
    Navigator.of(context).pop();
  }
}
