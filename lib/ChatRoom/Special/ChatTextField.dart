import 'package:flutter/material.dart';
import 'package:minor/VibeAndMorse/morsecheck.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:vibration/vibration.dart';

import 'SpecialChatBloc.dart';

class ChatTextField extends StatefulWidget {
  late final SpecialChatBloc _bloc;
  late final String path;
  ChatTextField(SpecialChatBloc b, TextEditingController m,
      TextEditingController t, int ma, String p) {
    _bloc = b;
    _morse = m;
    _text = t;
    max = ma;
    path = p;
  }
  late final TextEditingController _morse;
  late final TextEditingController _text;
  late final int max;
  _ChatTextFieldState createState() =>
      _ChatTextFieldState(_bloc, _morse, _text, max, path);
}

class _ChatTextFieldState extends State<ChatTextField> {
  late final SpecialChatBloc _bloc;
  late final String _path;
  _ChatTextFieldState(SpecialChatBloc b, TextEditingController m,
      TextEditingController t, int ma, String p) {
    _bloc = b;
    _morse = m;
    _text = t;
    max = ma;
    _path = p;
  }
  late final TextEditingController _morse;
  late final TextEditingController _text;
  late final int max;
  final MorseCheck _morseCheck = MorseCheck();
  final Vibes _vibes = Vibes();
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder<bool>(
        stream: _bloc.active,
        builder: (context, AsyncSnapshot<bool> snap) {
          print(snap.data);
          return SafeArea(
            child: Center(
              child: GestureDetector(
                onTertiaryTapCancel: () {
                  print('object');
                },
                onVerticalDragUpdate: (details) {
                  print('vertical');
                  //up swipe
                  if (details.delta.dy < -11 && snap.data!) {
                    _bloc.activeSink.add(false);
                    _morse.text = ',';
                    Vibration.vibrate(duration: 250);
                    Future.delayed(Duration(milliseconds: 250)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                  if (details.delta.dy > 11 && snap.data!) {
                    _bloc.activeSink.add(false);
                    _morse.text = 'dot';
                    Vibration.vibrate(duration: 250);
                    Future.delayed(Duration(milliseconds: 250)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                },
                onTap: () {
                  if (snap.data!) {
                    print('tap');
                    _morse.text = _morse.text + '.';
                    _bloc.activeSink.add(false);
                    Vibration.vibrate(duration: 50);
                    Future.delayed(Duration(milliseconds: 50)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                },
                onLongPress: () {
                  if (snap.data!) {
                    print('long');
                    _morse.text = _morse.text + '-';
                    _bloc.activeSink.add(false);
                    Vibration.vibrate(duration: 250);
                    Future.delayed(Duration(milliseconds: 250)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                },
                onDoubleTap: () {
                  if (snap.data!) {
                    print('double');
                    if (_morseCheck.check(_morse.text) == '') {
                      _bloc.activeSink.add(false);
                      _vibes.wrongVibe().then((value) {
                        _bloc.activeSink.add(true);
                      });
                    } else {
                      _bloc.activeSink.add(false);
                      print('morse: ' + _morse.text);
                      _text.text = _text.text + _morseCheck.check(_morse.text);
                      _morse.text = '';
                      print('actual: ' + _text.text);
                      Vibration.vibrate(duration: 400);
                      Future.delayed(Duration(milliseconds: 400)).then((value) {
                        _bloc.activeSink.add(true);
                      });
                    }
                  }
                },
                onHorizontalDragUpdate: (details) {
                  print('horizontal');
                  if (details.delta.dx > 11 && snap.data!) {
                    _bloc.activeSink.add(false);
                    if (_text.text == null) {
                      _bloc.pageControllSink.add('main');
                    } else if (_text.text == '') {
                      _bloc.pageControllSink.add('main');
                    } else {
                      _bloc.sendChat(_path, _text);
                    }
                  }
                  if (details.delta.dx < -11 && snap.data!) {
                    _bloc.activeSink.add(false);
                    _morse.clear();
                    _text.clear();
                    Vibration.vibrate(duration: 1500);
                    Future.delayed(Duration(milliseconds: 1500)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Color(0xff292B2F),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
