import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class SpecialChatBloc {
  /*
    *** CONSTRUCTOR ***
  */
  SpecialChatBloc(BuildContext _context) {
    _active = Provider.of<StreamController<bool>>(_context, listen: false);
    _chat = StreamController<int>.broadcast();
    _pagecontroll = StreamController<String>.broadcast();
  }

  /*
    *** DECLARATIONS ***
  */
  late final StreamController<bool> _active;
  late final StreamController<String> _pagecontroll;
  late final StreamController<int> _chat;

  /*
    *** METHODS ***
  */
  sendChat(String? path, TextEditingController chatcontroller) {
    int index = 0;
    String sender = '';
    String message = chatcontroller.text;
    chatcontroller.clear();
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
        FirebaseFirestore.instance.collection('chatRooms').doc(path).update({
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
                'message': message,
                'sender': sender,
                'timeStamp': time,
              },
            },
          ).then((value) {
            pageControllSink.add('main');
          });
        });
      });
    });
  }

  /*
    *** GETTERS ***
  */
  Stream<bool> get active => _active.stream;
  Stream<String> get pageControll => _pagecontroll.stream;
  Stream<int> get chat => _chat.stream;

  Sink<bool> get activeSink => _active.sink;
  Sink<String> get pageControllSink => _pagecontroll.sink;
  Sink<int> get chatSink => _chat.sink;
}
