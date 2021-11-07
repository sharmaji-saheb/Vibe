import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/Home/AddFriendUI.dart';
import 'package:minor/Home/HomeBloc.dart';
import 'package:minor/Themes/Fonts.dart';

class HomeUI {
  /*
    ***CONSTRUCTORS***
  */

  /*
    ***DECLARATIONS***
  */
  final ThemeFonts _fonts = ThemeFonts();
  final TextEditingController _textEditingController = TextEditingController();
  /*
    ***WIDGETS***
  */

  Widget addFriend(BuildContext context) {
    return AddFriend();
  }

  Widget chatList(BuildContext context,
      List<QueryDocumentSnapshot<Object?>> _list, String _email) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: ListView.builder(
          itemCount: _list.length + 1,
          itemBuilder: (context, index) {
            if (index == _list.length) {
              return Center(
                child: Container(
                  height: 50,
                  child: Center(
                    child: Text('END'),
                  ),
                ),
              );
            }
            List<dynamic> email = _list[index].get('email');
            String _otherEmail = '';
            for (String i in email) {
              if (i == _email) {
                continue;
              }
              _otherEmail = i;
            }
            Map<String, dynamic> map = _list[index].get('names');
            String _name = map[_otherEmail];
            return Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 55,
                      width: 55,
                      decoration: new BoxDecoration(
                        shape: BoxShape.circle,
                        image: new DecorationImage(
                          fit: BoxFit.fill,
                          image: new NetworkImage(
                            "https://i.imgur.com/BoN9kdC.png",
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    listTile(_name, _otherEmail, _email, context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listTile(
      String _name, String _otherEmail, String _email, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          FirebaseFirestore.instance
              .collection('chatRooms')
              .doc('${_email}&&${_otherEmail}')
              .get()
              .then((value) {
            if (value.exists) {
              Navigator.of(context).pushNamed(
                '/ChatRoom',
                arguments: ['${_email}&&${_otherEmail}', _name],
              );
            }else{
              Navigator.of(context).pushNamed(
                '/ChatRoom',
                arguments: ['${_otherEmail}&&${_email}', _name],
              );
            }
          });
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_name}',
                style: _fonts.loginButton(30),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'message',
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget? appBar(BuildContext _context, HomeBloc _bloc) {
    return AppBar(
      actions: [
        GestureDetector(
          onTap: _bloc.signOut,
          child: Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
        )
      ],
      elevation: 0,
      backgroundColor: Color(0xff292B2F),
      title: Text(
        'Minor',
        style: _fonts.scaffoldTitle(_context),
      ),
      toolbarHeight: MediaQuery.of(_context).size.height * 0.13,
    );
  }

  /*
    ***METHODS***
  */
}
