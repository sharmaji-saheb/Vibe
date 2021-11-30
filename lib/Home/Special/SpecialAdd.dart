import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:minor/VibeAndMorse/morsecheck.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:vibration/vibration.dart';

class SpecialAdd extends StatefulWidget {
  late final SpecialHomeBloc _bloc;
  SpecialAdd(SpecialHomeBloc b) {
    _bloc = b;
  }
  @override
  _SpecialAddState createState() => _SpecialAddState(_bloc);
}

class _SpecialAddState extends State<SpecialAdd> {
  late final SpecialHomeBloc _bloc;
  _SpecialAddState(SpecialHomeBloc b) {
    _bloc = b;
  }
  final TextEditingController _text = TextEditingController();
  final TextEditingController _morse = TextEditingController();
  final MorseCheck _morseCheck = MorseCheck();
  final Vibes _vibes = Vibes();
  @override
  Widget build(BuildContext context) {
    _text.text = '';
    return SafeArea(
      child: StreamBuilder<bool>(
        stream: _bloc.addPageControll,
        initialData: true,
        builder: (context, AsyncSnapshot<bool> page) {
          if (page.data!) {
            return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('publicInfo')
                  .where('email', isEqualTo: _text.text)
                  .get(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> query) {
                if (!query.hasData) {
                  return Container(
                    color: Color(0xff292B2F),
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                print(query.data!.docs.toString());
                return StreamBuilder<int>(
                  stream: _bloc.addPage,
                  initialData: 0,
                  builder: (context, AsyncSnapshot<int> ind) {
                    String _display = '';
                    if (ind.data == -1) {
                      _display = 'type';
                    }
                    int max = query.data!.docs.length;
                    if (max == 1 && ind.data == 1) {
                      _display = query.data!.docs[0]['name'];
                    }
                    return StreamBuilder<bool>(
                      stream: _bloc.active,
                      initialData: true,
                      builder: (context, AsyncSnapshot<bool> active) {
                        return GestureDetector(
                          onVerticalDragUpdate: (details) {
                            //up swipe
                            if (details.delta.dy < -11 && active.data!) {
                              if (ind.data == -1) {
                                if (max == 0) {
                                  _bloc.activeSink.add(false);
                                  _vibes.wrongVibe().then((value) {
                                    _bloc.activeSink.add(true);
                                  });
                                } else {
                                  _bloc.activeSink.add(false);
                                  _bloc.addPageSink.add(1);
                                  _vibes
                                      .vibrate(query.data!.docs[0]['name'])
                                      .then((value) {
                                    _bloc.activeSink.add(true);
                                  });
                                }
                              } else if (ind.data == 0) {
                                if (max == 0) {
                                  _bloc.activeSink.add(false);
                                  _vibes.wrongVibe().then((value) {
                                    _bloc.activeSink.add(true);
                                  });
                                } else {
                                  _bloc.activeSink.add(false);
                                  _bloc.addPageSink.add(1);
                                  _vibes
                                      .vibrate(query.data!.docs[0]['name'])
                                      .then((value) {
                                    _bloc.activeSink.add(true);
                                  });
                                }
                              } else if (ind.data == max) {
                                _bloc.activeSink.add(false);
                                _vibes.wrongVibe().then((value) {
                                  _bloc.activeSink.add(true);
                                });
                              }
                            }

                            //down swipe
                            else if (details.delta.dy > 11 && active.data!) {
                              if (ind.data == 1 || ind.data == 0) {
                                _bloc.activeSink.add(false);
                                _bloc.addPageSink.add(-1);
                                _vibes.vibrate('type').then((value) {
                                  _bloc.activeSink.add(true);
                                });
                              }

                              if (ind.data == -1) {
                                _bloc.activeSink.add(false);
                                _vibes.wrongVibe().then((value) {
                                  _bloc.activeSink.add(true);
                                });
                              }
                            }
                          },
                          onHorizontalDragUpdate: (details) {
                            if (details.delta.dx > 11 && active.data!) {
                              _bloc.activeSink.add(false);
                              _bloc.pageSink.add('main');
                              Vibration.vibrate(duration: 1500);
                              Future.delayed(Duration(milliseconds: 1500))
                                  .then((value) {
                                _bloc.activeSink.add(true);
                              });
                            }
                          },
                          onTap: () {
                            if (active.data!) {
                              if (ind.data! == -1) {
                                _bloc.activeSink.add(false);
                                _bloc.addPageContSink.add(false);
                                Vibration.vibrate(duration: 1500);
                                Future.delayed(Duration(milliseconds: 1500))
                                    .then((value) {
                                  _bloc.activeSink.add(true);
                                });
                              } else if (ind.data! == 1) {
                                _bloc.activeSink.add(false);
                                _bloc.addFriend(
                                    query.data!.docs[0].data()['email'],
                                    query.data!.docs[0].data()['name'],);
                              }
                            }
                          },
                          child: Container(
                            color: Color(0xff292B2F),
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(_display),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          }
          return textField();
        },
      ),
    );
  }

  Widget textField() {
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
                    _morse.text = '@';
                    Vibration.vibrate(duration: 250);
                    Future.delayed(Duration(milliseconds: 250)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                  if (details.delta.dy > 11 && snap.data!) {
                    _bloc.activeSink.add(false);
                    _morse.text = '.com';
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
                    }

                    else {
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
                    _bloc.addPageContSink.add(true);
                    _bloc.addPageSink.add(0);
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
