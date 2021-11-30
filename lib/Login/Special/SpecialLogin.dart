import 'package:flutter/material.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

import 'SpecialLoginBloc.dart';

class SpecialLogin extends StatefulWidget {
  const SpecialLogin({Key? key}) : super(key: key);

  @override
  _SpecialLoginState createState() => _SpecialLoginState();
}

class _SpecialLoginState extends State<SpecialLogin> {
  int _gestureEnabled = 1;
  final Vibes _vibe = Vibes();
  String button = '';
  @override
  Widget build(BuildContext context) {
    final SpecialLoginBloc _bloc = SpecialLoginBloc(context);
    return GestureDetector(
      onDoubleTap: () {
        if (button == 'mode' && _gestureEnabled == 1) {
          Vibration.vibrate(duration: 1500);
          Future.delayed(Duration(milliseconds: 1500)).then((value) {
            SharedPreferences.getInstance().then((value) {
              value.setString('mode', 'normal');
              Future.delayed(Duration(milliseconds: 500)).then((value) {
                _vibe.vibrate('restart the app').then((value) {
                  setState(() {
                    _gestureEnabled = 1;
                  });
                });
              });
            });
          });
        }
      },
      onTap: () {
        if (button == 'google' && _gestureEnabled == 1) {
          _bloc.gooogleSignIn();
        }
        if (button == 'email' && _gestureEnabled == 1) {
          Vibration.vibrate(duration: 1500);
          Navigator.pushNamed(context, '/EmailLogin').then((value) {
            setState(() {
              button = '';
            });
          });
        }
      },
      onVerticalDragUpdate: (details) {
        int sensitivity = 8;
        if (details.delta.dy > sensitivity) {
          // Down Swipe
          setState(() {
            if (button == 'email' && _gestureEnabled == 1) {
              _gestureEnabled = 0;
              button = 'google';
              _vibe.vibrate('google').then((value) {
                setState(() {
                  _gestureEnabled = 1;
                });
              });
            } else if (button == 'mode' && _gestureEnabled == 1) {
              _gestureEnabled = 0;
              button = 'email';
              _vibe.vibrate('email').then((value) {
                setState(() {
                  _gestureEnabled = 1;
                });
              });
            }
          });
        } else if (details.delta.dy < -sensitivity) {
          setState(() {
            if (button == '') {
              _gestureEnabled = 0;
              button = 'google';
              _vibe.vibrate('google').then((value) {
                setState(() {
                  _gestureEnabled = 1;
                });
              });
            }
            if (button == 'google' && _gestureEnabled == 1) {
              _gestureEnabled = 0;
              button = 'email';
              _vibe.vibrate('email').then((value) {
                setState(() {
                  _gestureEnabled = 1;
                });
              });
            }
            if (button == 'email' && _gestureEnabled == 1) {
              _gestureEnabled = 0;
              button = 'mode';
              _vibe.vibrate('mode').then((value) {
                setState(() {
                  _gestureEnabled = 1;
                });
              });
            }
          });
        }
      },
      child: Center(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Color(0xff292B2F),
          child: Center(
            child: Text(
              button,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
