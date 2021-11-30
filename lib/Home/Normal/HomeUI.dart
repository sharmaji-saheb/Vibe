import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minor/Home/Normal/AddFriendUI.dart';
import 'package:minor/Home/Normal/HomeBloc.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
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

  //addfriend ui
  Widget addFriend(BuildContext context) {
    return AddFriend();
  }

  //list of current chatrooms ie friends
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
            String _path = _list[index].id;
            String _otherEmail = '';
            for (String i in email) {
              if (i == _email) {
                continue;
              }
              _otherEmail = i;
            }
            Map<String, dynamic> map = _list[index].get('names');
            String _name = map[_otherEmail];

            int seen = _list[index].get('seen')[_email];
            int ind = _list[index].get('index');

            return Container(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: listTile(
                    _name, _otherEmail, _email, context, _path, ind, seen),
              ),
            );
          },
        ),
      ),
    );
  }

  //tiles for chat list
  Widget listTile(String _name, String _otherEmail, String _email,
      BuildContext context, String _path, int ind, int seen) {
    SpecialHomeBloc bloc = SpecialHomeBloc(context);
    String unread = '${ind - seen}';
    if (ind - seen == 0) {
      unread = '';
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/ChatRoom',
          arguments: [_path, _name, bloc],
        );
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Column(
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
                  _otherEmail,
                ),
              ],
            ),
            Expanded(
              child: SizedBox(),
            ),
            Text(
              unread,
              style: _fonts.loginButton(20),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
    );
  }

  //appbar for homescreen
  PreferredSizeWidget? appBar(BuildContext _context, HomeBloc _bloc) {
    return AppBar(
      actions: [
        GestureDetector(
          onTap: _bloc.changeMode,
          child: Icon(
            Icons.vibration_outlined,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 25,
        ),
        GestureDetector(
          onTap: _bloc.signOut,
          child: Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 10,
        ),
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
