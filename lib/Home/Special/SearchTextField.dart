import 'package:flutter/material.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:minor/VibeAndMorse/morsecheck.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:vibration/vibration.dart';

class SpecialTextField extends StatefulWidget {
  late final SpecialHomeBloc _bloc;
  SpecialTextField(
      SpecialHomeBloc b, TextEditingController m, TextEditingController t) {
    _bloc = b;
    _morse = m;
    _text = t;
  }
  late final TextEditingController _morse;
  late final TextEditingController _text;
  _SpecialTextFieldState createState() =>
      _SpecialTextFieldState(_bloc, _morse, _text);
}

class _SpecialTextFieldState extends State<SpecialTextField> {
  late final SpecialHomeBloc _bloc;
  _SpecialTextFieldState(
      SpecialHomeBloc b, TextEditingController m, TextEditingController t) {
    _bloc = b;
    _morse = m;
    _text = t;
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
                },
                onHorizontalDragUpdate: (details) {
                  print('horizontal');
                  if (details.delta.dx > 11 && snap.data!) {
                    _bloc.activeSink.add(false);
                    _bloc.pageControllSink.add(true);
                    _bloc.chatSink.add(-1);
                    Vibration.vibrate(duration: 1500);
                    Future.delayed(Duration(milliseconds: 1500)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                  if (details.delta.dx < -11 && snap.data!) {
                    _bloc.activeSink.add(false);
                    _morse.clear();
                    _text.clear();
                    Vibration.vibrate(duration: 750);
                    Future.delayed(Duration(milliseconds: 750)).then((value) {
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
