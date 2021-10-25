import 'package:flutter/material.dart';
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
  /*
    ***WIDGETS***
  */
  Widget bottomSheetSearchBar(
    dynamic _bloc,
    void Function()? _func,
    void Function(String)? onChanged,
    Stream<String> stream,
    FocusNode _node,
    TextEditingController _controller,
    TextStyle style,
    Widget child,
    bool obscured,
    TextInputType? keyBoardType) {
    return StreamBuilder(
      stream: stream,
      initialData: '',
      builder: (context, AsyncSnapshot<String> snapshot) {
        return TextField(
          onEditingComplete: _func,
          focusNode: _node,

          //setting state on changes to set error text
          onChanged: onChanged,
          controller: _controller,
          obscureText: obscured,
          cursorColor: Colors.white,
          style: style,
          keyboardType: keyBoardType,
          decoration: InputDecoration(
            errorText: snapshot.data,
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: 10,
                right: 7,
                top: 7,
                bottom: 7,
              ),
              child: child,
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
      },
    );
  }

  Widget addFriend(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showSlideUpView(context);
      },
      child: Icon(
        Icons.person_add_outlined,
      ),
    );
  }

  Widget friendsList(BuildContext context, List<String> _list) {
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
                    listTile(_list, index, context),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget listTile(List<String> _list, int index, BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: (){
          Navigator.of(context).pushNamed('/ChatRoom');
        },
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_list[index]}',
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
        TextButton.icon(
          onPressed: _bloc.signOut,
          icon: Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
          label: Text('logout'),
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
  showSlideUpView(BuildContext context) {
    showModalBottomSheet(
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
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
          ],
        );
      },
    );
  }
}
