import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:minor/Login/Special/SpecialLoginBloc.dart';
import 'package:minor/VibeAndMorse/morsecheck.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:vibration/vibration.dart';

class SpecialEmailLogin extends StatefulWidget {
  const SpecialEmailLogin({Key? key}) : super(key: key);

  @override
  _SpecialEmailLoginState createState() => _SpecialEmailLoginState();
}

class _SpecialEmailLoginState extends State<SpecialEmailLogin> {
  final Vibes _vibes = Vibes();
  final MorseCheck _morseCheck = MorseCheck();
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();
  TextEditingController _morse = TextEditingController();
  Widget build(BuildContext context) {
    final SpecialLoginBloc _bloc = SpecialLoginBloc(context);
    return SafeArea(
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _bloc.isInTextField,
        builder: (context, AsyncSnapshot<bool> snapshot) {
          Widget _widget = _loading();

          if (snapshot.data == false) {
            _widget = _mainScreen(context, _bloc);
          }

          if (snapshot.data == true) {
            _widget = _textField(context, _bloc);
          }
          return Center(
            child: _widget,
          );
        },
      ),
    );
  }

  Widget _loading() {
    return CircularProgressIndicator();
  }

  Widget _mainScreen(BuildContext context, SpecialLoginBloc _bloc) {
    List<String> _states = ['', 'email', 'pass', 'submit'];
    return StreamBuilder<int>(
      initialData: 0,
      stream: _bloc.select,
      builder: (context, AsyncSnapshot<int> snapshot) {
        int index = snapshot.data!;
        return StreamBuilder<bool>(
          stream: _bloc.active,
          initialData: true,
          builder: (context, AsyncSnapshot<bool> snap) {
            return GestureDetector(
              onTap: () {
                if (snap.data! && (index == 1 || index == 2)) {
                  _bloc.isInTextSink.add(true);
                  _bloc.activeSink.add(false);
                  Future.delayed(Duration(milliseconds: 1500)).then((value) {
                    _bloc.activeSink.add(true);
                  });
                  Vibration.vibrate(duration: 1500);
                }
                if (snap.data! && index == 3) {
                  _bloc.emailSignIn(_email.text, _pass.text);
                }
              },
              onHorizontalDragUpdate: (details) {
                print('horizontal');
                if (details.delta.dx > 11 && snap.data!) {
                  _bloc.activeSink.add(false);
                  _bloc.isInTextSink.add(false);
                  Vibration.vibrate(duration: 1500);
                  Future.delayed(Duration(milliseconds: 1500)).then((value) {
                    _bloc.activeSink.add(true);
                  });
                }
                if (details.delta.dx < -11 && snap.data!) {
                  _bloc.activeSink.add(false);
                  if (_morse.text.length != 0) {
                    _morse.clear();
                    Vibration.vibrate(duration: 750);
                    Future.delayed(Duration(milliseconds: 750)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  } else {
                    if (index == 1 && _email.text.length > 1) {
                      _email.text =
                          _email.text.substring(0, _email.text.length - 2);
                      Vibration.vibrate(duration: 750);
                      Future.delayed(Duration(milliseconds: 750)).then((value) {
                        _bloc.activeSink.add(true);
                      });
                    }
                    if (index == 2) {
                      _pass.text =
                          _pass.text.substring(0, _pass.text.length - 2);
                      Vibration.vibrate(duration: 750);
                      Future.delayed(Duration(milliseconds: 750)).then((value) {
                        _bloc.activeSink.add(true);
                      });
                    }
                  }
                }
              },
              onVerticalDragUpdate: (details) {
                int sensitivity = 11;

                //up swipe
                if (details.delta.dy < -sensitivity &&
                    snap.data! &&
                    index < 3) {
                  print('object');
                  _bloc.activeSink.add(false);
                  _bloc.selectSink.add(index + 1);
                  _vibes.vibrate(_states[index + 1]).then((value) {
                    _bloc.activeSink.add(true);
                  });
                } else if (details.delta.dy > sensitivity &&
                    snap.data! &&
                    index > 1) {
                  _bloc.activeSink.add(false);
                  _bloc.selectSink.add(index - 1);
                  _vibes.vibrate(_states[index - 1]).then((value) {
                    _bloc.activeSink.add(true);
                  });
                }
              },
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Color(0xff292B2F),
                child: Center(
                  child: Text(_states[snapshot.data!]),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _textField(BuildContext context, SpecialLoginBloc _bloc) {
    int lastTap = DateTime.now().millisecondsSinceEpoch;
    int consecutiveTaps = 0;
    return StreamBuilder<int>(
      initialData: 1,
      stream: _bloc.select,
      builder: (context, AsyncSnapshot<int> snapshot) {
        int index = snapshot.data!;

        return StreamBuilder<bool>(
          initialData: false,
          stream: _bloc.active,
          builder: (context, AsyncSnapshot<bool> snap) {
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
                      if (index == 1) {
                        _bloc.activeSink.add(false);
                        _morse.text = '@';
                        Vibration.vibrate(duration: 250);
                      }
                      if (index == 2) {
                        _bloc.activeSink.add(false);
                        _morse.text = ',';
                        Vibration.vibrate(duration: 250);
                      }
                    }
                    if (details.delta.dy > 11 && snap.data!) {
                      if (index == 1) {
                        _bloc.activeSink.add(false);
                        _morse.text = '.com';
                        Vibration.vibrate(duration: 250);
                      }
                      if (index == 2) {
                        _bloc.activeSink.add(false);
                        _morse.text = 'dot';
                        Vibration.vibrate(duration: 250);
                      }
                    }
                  },
                  onTap: () {
                    print('tap');
                    _morse.text = _morse.text + '.';
                    _bloc.activeSink.add(false);
                    Vibration.vibrate(duration: 50);
                    Future.delayed(Duration(milliseconds: 50)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  },
                  onLongPress: () {
                    print('long');
                    _morse.text = _morse.text + '-';
                    _bloc.activeSink.add(false);
                    Vibration.vibrate(duration: 250);
                    Future.delayed(Duration(milliseconds: 250)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  },
                  onDoubleTap: () {
                    print('double');
                    if (_morseCheck.check(_morse.text) == '') {
                      _bloc.activeSink.add(false);
                      _vibes.wrongVibe().then((value) {
                        _bloc.activeSink.add(true);
                      });
                    }
                    if (index == 1) {
                      _bloc.activeSink.add(false);
                      print('morse: ' + _morse.text);
                      _email.text =
                          _email.text + _morseCheck.check(_morse.text);
                      _morse.text = '';
                      print('actual: ' + _email.text);
                      Vibration.vibrate(duration: 400);
                      Future.delayed(Duration(milliseconds: 400)).then((value) {
                        _bloc.activeSink.add(true);
                      });
                    }
                    if (index == 2) {
                      _bloc.activeSink.add(false);
                      print('morse: ' + _morse.text);
                      _pass.text = _pass.text + _morseCheck.check(_morse.text);
                      _morse.text = '';
                      print('actual: ' + _pass.text);
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
                      _morse.clear();
                      _bloc.isInTextSink.add(false);
                      Vibration.vibrate(duration: 1500);
                      Future.delayed(Duration(milliseconds: 1500))
                          .then((value) {
                        _bloc.activeSink.add(true);
                      });
                    }
                    if (details.delta.dx < -11 && snap.data!) {
                      if (index == 1) {
                        _bloc.activeSink.add(false);
                        _email.clear();
                        _morse.clear();
                        Vibration.vibrate(duration: 1500);
                        Future.delayed(Duration(milliseconds: 1500))
                            .then((value) {
                          _bloc.activeSink.add(true);
                        });
                      } else if (index == 2) {
                        _bloc.activeSink.add(false);
                        _pass.clear();
                        _morse.clear();
                        Vibration.vibrate(duration: 1500);
                        Future.delayed(Duration(milliseconds: 1500))
                            .then((value) {
                          _bloc.activeSink.add(true);
                        });
                      }
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
        );
      },
    );
  }
}
