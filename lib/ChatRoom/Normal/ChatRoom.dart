
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/ChatRoom/Normal/ChatList.dart';
import 'package:minor/ChatRoom/Normal/ChatRoomUi.dart';
import 'package:minor/ChatRoom/Normal/SendChat.dart';
import 'package:minor/ChatRoom/Special/SpecialChatScreen.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:provider/provider.dart';
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
    final String _path = args![0];
    final String _name = args![1];
    final SpecialHomeBloc _prevBloc = args![2];
    String _mode =Provider.of<String>(context, listen: false);
     

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
                child: _chatList.chatList(_path),
              ),
              SendChat().TxtFieldAndButton(_path),
            ],
          ),
        ],
      ),
    );
  }
}
