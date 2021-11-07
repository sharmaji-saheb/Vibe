import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/ChatRoom/ChatList.dart';
import 'package:minor/ChatRoom/ChatRoomUi.dart';
import 'package:minor/ChatRoom/SendChat.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
  CHATROOM, READ AND SEND CHATS
*/
class ChatRoom extends StatefulWidget {
  late List? args;
  ChatRoom({Key? key, this.args}) : super(key: key);
  _ChatRoomState createState() => _ChatRoomState(args: args);
}

class _ChatRoomState extends State<ChatRoom> {
  //args containing name and email of whose chatroom it is
  late final List? args;
  _ChatRoomState({this.args});

  //TextEditingController for textfield
  final TextEditingController chatcontroller = TextEditingController();

  //class for list of chats
  final ChatList _chatList = ChatList();

  //_ui for chats
  final ChatRoomUi _ui = ChatRoomUi();

  /*
    ****BUILD***
  */
  Widget build(BuildContext context) {
    //path in firestore for chat and name 
    final String? path = args![0];
    final String _name = args![1];
    return Scaffold(
      appBar: _ui.appBar(context, _name),
      body: Stack(
        children: [
          Container(
            color: Color(0xff2E3036),
          ),

          //Column having chat list and textfield
          Column(
          children: [
            Expanded(
              child: _chatList.chatList(path),
            ),
            SendChat().TxtFieldAndButton(path),
          ],
        ),]
      ),
    );
  }
}
