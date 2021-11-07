import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoomBloc{
  /*
    ***DECLARATION***
  */
  /*
    ***METHODS***
  */
  //Method to send chat
  sendChat(String? path, TextEditingController chatcontroller){
    int index = 0;
                String sender = '';
                SharedPreferences.getInstance().then((value) {
                  sender = value.getString('name')!;
                  FirebaseFirestore.instance
                      .collection('chatRooms')
                      .doc(
                        path,
                      )
                      .get()
                      .then((value) {
                    index = value.data()!['index'];
                    int time = DateTime.now().microsecondsSinceEpoch;
                    FirebaseFirestore.instance
                        .collection('chatRooms')
                        .doc(path)
                        .update({
                      'index': index + 1,
                      'latestTime': time,
                    }).then((value) {
                      FirebaseFirestore.instance
                          .collection('chatRooms')
                          .doc(path)
                          .collection('messages')
                          .doc('messages')
                          .update(
                        {
                          '${index}': {
                            'message': chatcontroller.text,
                            'sender': sender,
                            'timeStamp': time,
                          },
                        },
                      );
                    });
                  });
                });
  }
}