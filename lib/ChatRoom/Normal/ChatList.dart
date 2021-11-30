import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/Themes/Fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
        SharedPreferences.getInstance().then((value) {
      String e= value.getString('email')!;
      FirebaseFirestore.instance.collection('chatRooms').doc(path).get().then((v){
        int ind = v.data()!['index'];
        Map<String, dynamic> s = v.data()!['seen'];
        s[e] = ind;
        print(ind.toString() + e + s.toString());
        FirebaseFirestore.instance.collection('chatRooms').doc(path).update({'seen': s});
      });
    });  

        int index = snapshot.data!.data()!.length;

        return Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            //List for chats
            child: FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, AsyncSnapshot<SharedPreferences> shared) {
                if(!shared.hasData){
                  return Container();
                } else if(shared.data == null){
                  return Container();
                }

                String _ownName = shared.data!.getString('name')!;
                
                return ListView.builder(
                  reverse: true,
                  shrinkWrap: true,
                  controller: _scrollController,
                  itemCount: index,
                  itemBuilder: (context, ind) {
                    int i = index - ind - 1;
                    Map<String, dynamic> map = snapshot.data!.data()!['${i}'];
                    String message = map['message'];
                    String sender = map['sender'];

                    //Tile for displaying indivisual messages
                    return chatTile(sender, message, _ownName);
                  },
                );
              },
            ));
      },
    );
  }

  //Tile for displaying indivisual messages
  Widget chatTile(String _name, String _message, String _ownName) {
    Color color = Color(0xff1D1F30);
    if(_name != _ownName){
      color = Colors.black;
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(7)),
        child: Container(
          color: color,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
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
                      width: 10,
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
                      width: 10,
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
        ),
      ),
    );
  }
}
