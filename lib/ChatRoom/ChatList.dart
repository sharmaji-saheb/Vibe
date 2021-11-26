import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minor/Themes/Fonts.dart';

class ChatList {
  //fonts and theme
  final ThemeFonts _fonts = ThemeFonts();
  final ScrollController _scrollController = ScrollController();
  //Chats List View
  Widget chatList(String? path) {
    //StreamBuilder constantly updating chats
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection('chatRooms')
          .doc(
            path,
          )
          .collection('messages')
          .doc('messages')
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        if (snapshot.data == null) {
          return Container();
        }
        if (snapshot.data!.data() == null) {
          return Container();
        }
        int index = snapshot.data!.data()!.length;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          //List for chats
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            controller: _scrollController,
            itemCount: index,
            itemBuilder: (context, ind) {
              int i = index - ind -1;
              Map<String, dynamic> map = snapshot.data!.data()!['${i}'];
              String message = map['message'];
              String sender = map['sender'];

              //Tile for displaying indivisual messages
              return chatTile(sender, message);
            },
          ),
        );
      },
    );
  }

  //Tile for displaying indivisual messages
  Widget chatTile(String _name, String _message) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Container(
        color: Color(000000).withAlpha(175),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: Text(
                    _name,
                    style: _fonts.chatTileName(),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 4,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 3,
                ),
                Expanded(
                  child: Text(
                    _message,
                    style: _fonts.chatTileMessage(),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
