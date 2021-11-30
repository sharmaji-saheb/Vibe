import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/ChatRoom/Special/ChatTextField.dart';
import 'package:minor/ChatRoom/Special/SpecialChatBloc.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:vibration/vibration.dart';

class SpecialChatScreen extends StatefulWidget {
  late final SpecialHomeBloc prevBloc;
  late final String name;
  late final String path;
  late final String email;
  late final String otherEmail;
  SpecialChatScreen(
      String p, String n, String e, String oe, SpecialHomeBloc _pb) {
    prevBloc = _pb;
    path = p;
    name = n;
    email = e;
    otherEmail = oe;
  }
  @override
  _SpecialChatScreenState createState() =>
      _SpecialChatScreenState(path, name, email, otherEmail, prevBloc);
}

class _SpecialChatScreenState extends State<SpecialChatScreen> {
  late final SpecialHomeBloc _prevBloc;
  late final String _name;
  late final String _email;
  late final String _path;
  late final String _otherEmail;
  final TextEditingController _morse = TextEditingController();
  final TextEditingController _text = TextEditingController();
  _SpecialChatScreenState(
      String p, String n, String e, String oe, SpecialHomeBloc _pb) {
    _prevBloc = _pb;
    _path = p;
    _name = n;
    _email = e;
    _otherEmail = oe;
  }
  final Vibes _vibes = Vibes();
  Widget build(BuildContext context) {
    final SpecialChatBloc _bloc = SpecialChatBloc(context);
    int max = 0;
    return StreamBuilder<String>(
      initialData: 'main',
      stream: _bloc.pageControll,
      builder: (context, AsyncSnapshot<String> pagecont) {
        if (pagecont.data! == 'null') {
          return _normalCont();
        }
        if (pagecont.data! == 'text') {
          return ChatTextField(_bloc, _morse, _text, max, _path);
        }

        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('chatRooms')
              .doc(_path)
              .get(),
          builder: (BuildContext context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> chatInfo) {
            if (!chatInfo.hasData) {
              return _normalCont();
            }
            if (chatInfo.data == null) {
              return _normalCont();
            }
            return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('chatRooms')
                  .doc(_path)
                  .collection('messages')
                  .doc('messages')
                  .get(),
              builder: (context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> chats) {
                if (!chats.hasData) {
                  return _normalCont();
                } else if (chats.data == null) {
                  return _normalCont();
                }

                print('object:::::::::::;' + _otherEmail + _email);
                int seen = chatInfo.data!.data()!['seen'][_email];
                int otherSeen = chatInfo.data!.data()!['seen'][_otherEmail];

                Map<String, dynamic> _map = chats.data!.data()!;
                int max = 0;
                if (chats.data!.data() == null) {
                  max = 0;
                } else {
                  max = chats.data!.data()!.length;
                }

                _bloc.activeSink.add(false);
                _bloc.chatSink.add(seen);
                if (seen == max) {
                  Vibration.vibrate(duration: 1500);
                  Future.delayed(Duration(milliseconds: 1500)).then((value) {
                    _bloc.activeSink.add(true);
                  });
                } else {
                  if (chats.data!.data()!['${seen}']['sender'] == _name) {
                    Vibration.vibrate(duration: 1000);
                    Future.delayed(Duration(milliseconds: 1000)).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  } else {
                    Vibration.vibrate(duration: 500);
                    Future.delayed(Duration(milliseconds: 500)).then((value) {
                      Future.delayed(Duration(milliseconds: 400)).then((value) {
                        Vibration.vibrate(duration: 500);
                        Future.delayed(Duration(milliseconds: 500))
                            .then((value) {
                          _bloc.activeSink.add(true);
                        });
                      });
                    });
                  }
                }
                return StreamBuilder<int>(
                  stream: _bloc.chat,
                  initialData: seen,
                  builder: (context, AsyncSnapshot<int> ind) {
                    String text = '';
                    if (ind.data! < max) {
                      text = _map['${ind.data!}']['sender'] +
                          ':: ' +
                          _map['${ind.data!}']['message'];
                    } else {
                      if (ind.data! == max + 1) {
                        text = 'type';
                      }
                    }
                    return StreamBuilder<bool>(
                      initialData: true,
                      stream: _bloc.active,
                      builder: (context, AsyncSnapshot<bool> activess) {
                        int currIndex = ind.data!;
                        bool currActive = activess.data!;
                        return GestureDetector(
                          onVerticalDragUpdate: (details) {
                            //up swipe
                            if (details.delta.dy < -11 &&
                                currActive &&
                                currIndex < max + 1) {
                              _bloc.activeSink.add(false);
                              if (currIndex == max - 1) {
                                _bloc.chatSink.add(max + 1);
                                _vibes.vibrate('type').then((value) {
                                  _bloc.activeSink.add(true);
                                });
                              } else {
                                if (currIndex < max - 1) {
                                  _bloc.chatSink.add(currIndex + 1);
                                  if (_map["${currIndex + 1}"]['sender'] ==
                                      _name) {
                                    Vibration.vibrate(duration: 1000);
                                    Future.delayed(Duration(milliseconds: 1000))
                                        .then((value) {
                                      _bloc.activeSink.add(true);
                                    });
                                  } else {
                                    Vibration.vibrate(duration: 500);
                                    Future.delayed(Duration(milliseconds: 500))
                                        .then((value) {
                                      Future.delayed(
                                              Duration(milliseconds: 400))
                                          .then((value) {
                                        Vibration.vibrate(duration: 500);
                                        Future.delayed(
                                                Duration(milliseconds: 500))
                                            .then((value) {
                                          _bloc.activeSink.add(true);
                                        });
                                      });
                                    });
                                  }
                                } else {
                                  _bloc.chatSink.add(currIndex + 1);
                                  String str = '';
                                  if (currIndex + 1 == max + 1) {
                                    str = 'type';
                                  }
                                  _vibes.vibrate(str).then((value) {
                                    _bloc.activeSink.add(true);
                                  });
                                }
                              }
                            }

                            //down swipe
                            if (details.delta.dy > 11 &&
                                currActive &&
                                currIndex > 0) {
                              _bloc.activeSink.add(false);
                              if (currIndex == max + 1) {
                                if (max == 0) {
                                  _vibes.wrongVibe().then((value) {
                                    _bloc.activeSink.add(true);
                                  });
                                } else {
                                  _bloc.chatSink.add(max - 1);
                                  if (_map['${max - 1}']['sender'] == _name) {
                                    Vibration.vibrate(duration: 1000);
                                    Future.delayed(Duration(milliseconds: 1000))
                                        .then((value) {
                                      _bloc.activeSink.add(true);
                                    });
                                  } else {
                                    Vibration.vibrate(duration: 500);
                                    Future.delayed(Duration(milliseconds: 500))
                                        .then((value) {
                                      Future.delayed(
                                              Duration(milliseconds: 400))
                                          .then((value) {
                                        Vibration.vibrate(duration: 500);
                                        Future.delayed(
                                                Duration(milliseconds: 500))
                                            .then((value) {
                                          _bloc.activeSink.add(true);
                                        });
                                      });
                                    });
                                  }
                                }
                              } else {
                                _bloc.chatSink.add(currIndex - 1);
                                int dur = 1500;
                                if (_map['${currIndex - 1}']['sender'] ==
                                    _name) {
                                  Vibration.vibrate(duration: 1000);
                                  Future.delayed(Duration(milliseconds: 1000))
                                      .then((value) {
                                    _bloc.activeSink.add(true);
                                  });
                                } else {
                                  Vibration.vibrate(duration: 500);
                                  Future.delayed(Duration(milliseconds: 500))
                                      .then((value) {
                                    Future.delayed(Duration(milliseconds: 400))
                                        .then((value) {
                                      Vibration.vibrate(duration: 500);
                                      Future.delayed(
                                              Duration(milliseconds: 500))
                                          .then((value) {
                                        _bloc.activeSink.add(true);
                                      });
                                    });
                                  });
                                }
                              }
                            }
                          },
                          onHorizontalDragUpdate: (details) {
                            if (details.delta.dx > 11 && activess.data!) {
                              _prevBloc.pageControllSink.add(true);
                            }
                          },
                          onTap: () {
                            if (currActive) {
                              _bloc.activeSink.add(false);
                              if (currIndex < max) {
                                _vibes
                                    .vibrate(_map['${currIndex}']['message'])
                                    .then((value) {
                                  _bloc.activeSink.add(true);
                                });
                              } else if (currIndex == max) {
                                _vibes.wrongVibe().then((value) {
                                  _bloc.activeSink.add(true);
                                });
                              } else if (currIndex == max + 1) {
                                _bloc.pageControllSink.add('text');
                                Vibration.vibrate(duration: 1500);
                                Future.delayed(Duration(milliseconds: 1500))
                                    .then((value) {
                                  _bloc.activeSink.add(true);
                                });
                              }
                            }
                          },
                          onDoubleTap: () {
                            _bloc.activeSink.add(false);
                            FirebaseFirestore.instance
                                .collection('chatRooms')
                                .doc(_path)
                                .update({
                              'seen': {
                                _email: max,
                                _otherEmail: otherSeen,
                              }
                            }).then((value) {
                              _bloc.pageControllSink.add('main');
                              _bloc.activeSink.add(true);
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height,
                            width: MediaQuery.of(context).size.width,
                            color: Color(0xff292B2F),
                            child: Center(
                              child: Text(text),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _normalCont() {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Color(0xff292B2F),
      child: Center(),
    );
  }
}
