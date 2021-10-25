import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatRoom extends StatefulWidget {
  const ChatRoom({Key? key}) : super(key: key);

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController chatcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(
                      'ZUb9XMgW44MQfM7Yl8V11RLtzRn2&&LOBVtfxf1Ggfjyu4pB8YUYK69aJ2')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                if (snapshot.data == null) {
                  return Container();
                }
                if (snapshot.data!.data() == null) {
                  return Container();
                }
                print(snapshot.data);
                print(snapshot.data!.data());
                int index = snapshot.data!.data()!.length - 1;
                return ListView.builder(
                  itemCount: index,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> map =
                        snapshot.data!.data()!['${index}'];
                    String message = map['message'];
                    String senderuid = map['sender'];
                    String sender  = snapshot.data!.data()!['names'][senderuid];
                    String str = "${sender}:: ${message}";
                    return Text(str);
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: chatcontroller,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  int index = 0;
                  FirebaseFirestore.instance
                      .collection('chatRooms')
                      .doc(
                          'ZUb9XMgW44MQfM7Yl8V11RLtzRn2&&LOBVtfxf1Ggfjyu4pB8YUYK69aJ2index')
                      .get()
                      .then((value) {
                    index = value.data()!['index'];
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection('chatRooms')
                        .doc(
                            'ZUb9XMgW44MQfM7Yl8V11RLtzRn2&&LOBVtfxf1Ggfjyu4pB8YUYK69aJ2')
                        .update({
                      '${index}': {
                        'sender': 'ZUb9XMgW44MQfM7Yl8V11RLtzRn2',
                        'timestamp': DateTime.now().microsecondsSinceEpoch,
                        'message': chatcontroller.text,
                      }
                    });
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection('chatRooms')
                        .doc(
                            'ZUb9XMgW44MQfM7Yl8V11RLtzRn2&&LOBVtfxf1Ggfjyu4pB8YUYK69aJ2index')
                        .set({'index': index + 1});
                  });
                },
                child: Text('send'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
