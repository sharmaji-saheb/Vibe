import 'package:flutter/material.dart';
import 'package:minor/ChatRoom/Normal/ChatRoomBloc.dart';
import 'package:minor/Themes/Fonts.dart';

class SendChat {
  /*
    ***DECLARATIONS***
  */
  //fonts
  final ThemeFonts _fonts = ThemeFonts();

  /*
    ***WIDGETS***
  */
  //textfield for writing and sending chats
  Widget TxtFieldAndButton(String? path) {
    //BLOC
    final ChatRoomBloc _bloc = ChatRoomBloc();
    //chat field controller
    final TextEditingController chatcontroller = TextEditingController();
    return Padding(
      padding: EdgeInsets.all(6),
      child: TextField(
        controller: chatcontroller,
        cursorColor: Colors.white,
        style: _fonts.loginText(),
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: EdgeInsets.only(
              left: 10,
              right: 7,
              top: 7,
              bottom: 7,
            ),
            child: GestureDetector(
              child: Icon(
                Icons.send_outlined,
                color: Colors.white,
              ),
              onTap: () {
                if (chatcontroller.text != null) {
                  if (chatcontroller.text != '') {
                    _bloc.sendChat(path, chatcontroller);
                  }
                }
              },
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
    );
  }
}
