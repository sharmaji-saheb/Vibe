import 'package:flutter/material.dart';
 import 'package:minor/Themes/Fonts.dart';

class LoginUIComponents {
  final ThemeFonts _fonts = ThemeFonts();

  Widget loginButton(BuildContext context, dynamic _bloc, void Function()? func,
      TextEditingController _email, TextEditingController _pass, String text) {
    //ClipRRect for Rounded Border
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(7)),
      child: Container(
        height: 50,
        child: StreamBuilder(
          initialData: false,
          stream: _bloc.login_button,
          builder: (context, AsyncSnapshot<bool> snapshot) {
            void Function()? _func = null;
            if (snapshot.data == null ||
                _email.text == '' ||
                _pass.text == '') {
            } else if (snapshot.data!) {
              _func = func;
            }
            return ElevatedButton(
              //_loginButtonOnPressed is login Function()?
              onPressed: _func,
              child: Text(
                text,
                style: _fonts.loginButton(35),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (state) {
                    return Color(0xff383D6C);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget loginTextFields(
      dynamic _bloc,
      void Function()? _func,
      void Function(String)? onChanged,
      Stream<String> stream,
      FocusNode _node,
      TextEditingController _controller,
      TextStyle style,
      Widget child,
      bool obscured,
      TextInputType? keyBoardType) {
    return StreamBuilder(
      stream: stream,
      initialData: '',
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onEditingComplete: _func,
          focusNode: _node,

          //setting state on changes to set error text
          onChanged: onChanged,
          controller: _controller,
          obscureText: obscured,
          cursorColor: Colors.white,
          style: style,
          keyboardType: keyBoardType,
          decoration: InputDecoration(
            errorText: snapshot.data,
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 7,
                top: 7,
                bottom: 7,
              ),
              child: child,
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

  Widget loginPageButton(void Function()? _onPressed, int color,
      TextStyle? font, Widget child, String text) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(2)),
      child: Container(
        height: 60,
        child: ElevatedButton(
          //redirects to Email login screen
          onPressed: _onPressed,

          //Row for button contents
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //email logo
              child,
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      style: font,
                    ),
                  ],
                ),
              ),
            ],
          ),
          style: ButtonStyle(backgroundColor:
              MaterialStateProperty.resolveWith<Color>((state) {
            return Color(color);
          })),
        ),
      ),
    );
  }
}
