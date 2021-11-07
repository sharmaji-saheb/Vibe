import 'package:flutter/material.dart';
import 'package:minor/Home/HomeBloc.dart';
import 'package:minor/Themes/Fonts.dart';

class ChatRoomUi {
  final ThemeFonts _fonts = ThemeFonts();

  //appbar for chatroom
  PreferredSizeWidget? appBar(BuildContext _context, String name) {
    return AppBar(
      elevation: 0,
      backgroundColor: Color(0xff292B2F),
      title: Text(
        name,
        style: _fonts.chatScaffoldTitle(_context),
      ),
      toolbarHeight: MediaQuery.of(_context).size.height * 0.13,
    );
  }
}
