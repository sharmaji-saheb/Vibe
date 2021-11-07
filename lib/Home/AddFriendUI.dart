import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/Themes/Fonts.dart';
import 'HomeBloc.dart';

class AddFriend extends StatefulWidget {
  const AddFriend({ Key? key }) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  final ThemeFonts _fonts = ThemeFonts();
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showSlideUpView(context);
      },
      child: Icon(
        Icons.person_add_outlined,
      ),
    );
  }

  showSlideUpView(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      clipBehavior: Clip.antiAlias,
      backgroundColor: Color(0xff292B2F),
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
      ),
      builder: (context) {
        final HomeBloc _bloc = HomeBloc(context);
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              bottomSheetSearchBar(context, _bloc),
              SizedBox(
                height: 5,
              ),
              addfriendsList(_bloc),
            ],
          ),
        );
      },
    );
  }

  Widget addFriendsTile(String _name, String _email, HomeBloc _bloc) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: GestureDetector(
          onTap: () {
            _bloc.addFriend(_email, _name);
          },
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
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _name,
                        style: _fonts.loginButton(30),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        _email,
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Icon(
                  Icons.person_add_outlined,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget addfriendsList(HomeBloc _bloc) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(bottom: 5, right: 10, left: 10),
        child: StreamBuilder<String>(
          stream: _bloc.searchStream,
          builder: (context, AsyncSnapshot<String> snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else if (snapshot.data == null) {
              return Container();
            }

            String _email = snapshot.data!;
            if (_email == '') {
              _email = '@';
            }
            print(_email);

            Query<Map<String, dynamic>> ans = FirebaseFirestore.instance
                .collection('publicInfo')
                .where('email', isGreaterThanOrEqualTo: _email);

            return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: ans.get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snap) {
                if (!snap.hasData) {
                  return Container();
                } else if (snapshot.data == null) {
                  return Container();
                }

                return ListView.builder(
                  itemCount: snap.data!.docs.length + 1,
                  itemBuilder: (context, index) {
                    print(index);
                    if (index == snap.data!.docs.length) {
                      return Center(
                        child: Container(
                          height: 50,
                          child: Text('END'),
                        ),
                      );
                    }
                    String _n = snap.data!.docs[index].data()['name'];
                    String _e = snap.data!.docs[index].data()['email'];
                    return addFriendsTile(_n, _e, _bloc);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
  
  Widget bottomSheetSearchBar(
    BuildContext context,
    HomeBloc _bloc,
  ) {
    return TextField(
      onEditingComplete: FocusScope.of(context).unfocus,
      onChanged: (text) {
        _bloc.searchSink.add(text);
      },
      cursorColor: Colors.white,
      style: _fonts.loginText(),
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: EdgeInsets.only(
            left: 10,
            right: 7,
            top: 7,
            bottom: 7,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            child: Icon(
              Icons.person_add_outlined,
              color: Colors.white,
              size: 30,
            ),
          ),
        ),
        contentPadding: EdgeInsets.only(
          right: 7,
          left: 5,
        ),
        fillColor: Color(0xff474A51),
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(
            Radius.circular(7),
          ),
        ),
      ),
    );
  }
}