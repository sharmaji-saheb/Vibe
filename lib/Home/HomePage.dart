import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor/Themes/Fonts.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

//Mixin for ticker provider
class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  //tab controller
  late final TabController _tab_controller;

  @override
  void initState() {
    super.initState();
    _tab_controller = TabController(vsync: this, length: 2, initialIndex: 0);
  }

  //Themes and Fonts
  final ThemeFonts _fonts = ThemeFonts();

  Widget build(BuildContext context) {
    //instance of google sign in
    final GoogleSignIn _google_sign_in =
        Provider.of<GoogleSignIn>(context, listen: false);
    //isntance of FirebaseAuth
    final FirebaseAuth _auth =
        Provider.of<FirebaseAuth>(context, listen: false);

    Widget w = Text('');
    var a = _google_sign_in.currentUser;
    if(a != null)
    {w=Text('a=${a.displayName}');}
    else{w=Text('null');}

    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xff2E3036),
        appBar: AppBar(
          bottom: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            unselectedLabelColor: Colors.red,
            indicator: BoxDecoration(
              color: Color(0xff2E3036),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5),)
            ),
            controller: _tab_controller,
            tabs: [
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Icon(
                  Icons.message_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 5),
                child: Icon(
                  Icons.person_outline,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ],
          ),
          elevation: 0,
          backgroundColor: Color(0xff292B2F),
          title: Text(
            'Minor',
            style: _fonts.scaffoldTitle(context),
          ),
          toolbarHeight: MediaQuery.of(context).size.height * 0.13,
        ),

        //stack having children:-
        //container for background
        //and Padding with child column with login buttons
        body: Stack(
          children: [
            //Container for background
            Container(
              color: Color(0xff2E3036),
            ),

            //TabView
            TabBarView(
              physics: BouncingScrollPhysics(),
              controller: _tab_controller,
              children: [
                ElevatedButton(
                  onPressed: () async {
              if (await _google_sign_in.isSignedIn()) {
                await _google_sign_in.disconnect();
                await _auth.signOut();
              }else{
                _auth.signOut();
              }
            },
                  child: Text('l'),
                ),
                w,
              ],
            )
          ],
        ),
      ),
    );
  }
}

//Logout metthod
// () async {
//               if (await _google.isSignedIn()) {
//                 await _google.disconnect();
//                 await _auth.signOut();
//               }else{
//                 _auth.signOut();
//               }
//             },