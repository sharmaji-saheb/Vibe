import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/ChatRoom/Special/SpecialChatBloc.dart';
import 'package:minor/ChatRoom/Special/SpecialChatScreen.dart';
import 'package:minor/Home/Special/SearchTextField.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class ChatPageSpecial extends StatefulWidget {
  ChatPageSpecial(SpecialHomeBloc bloc) {
    _bloc = bloc;
  }
  late final SpecialHomeBloc _bloc;

  @override
  _ChatPageSpecialState createState() => _ChatPageSpecialState(_bloc);
}

class _ChatPageSpecialState extends State<ChatPageSpecial> {
  final Vibes _vibes = Vibes();
  late final SpecialHomeBloc _bloc;
  _ChatPageSpecialState(SpecialHomeBloc b) {
    _bloc = b;
  }
  String _path = '';
  String _name = '';
  String _email = '';
  String _otherEmail = '';

  final TextEditingController _text = TextEditingController();
  final TextEditingController _morse = TextEditingController();
  bool text = false;

  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<bool>(
        initialData: true,
        stream: _bloc.pageControll,
        builder: (context, AsyncSnapshot<bool> pageCon) {
          if (pageCon.data!) {
            return FutureBuilder<SharedPreferences>(
              future: SharedPreferences.getInstance(),
              builder: (context, AsyncSnapshot<SharedPreferences> shared) {
                if (!shared.hasData) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xff292B2F),
                  );
                }
                if (shared.data == null) {
                  return Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Color(0xff292B2F),
                  );
                }

                _email = shared.data!.getString('email')!;
                _name = shared.data!.getString('name')!;
                return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection('chatRooms')
                      .where('email', arrayContains: _email)
                      .orderBy('latestTime', descending: true)
                      .orderBy('index')
                      .get(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          queryss) {
                    if (!queryss.hasData) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xff292B2F),
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (queryss.data == null) {
                      return Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Color(0xff292B2F),
                        child: CircularProgressIndicator(),
                      );
                    }
                    _bloc.activeSink.add(false);
                    List<QueryDocumentSnapshot<Map<String, dynamic>>> _list =
                        queryss.data!.docs;
                    List<String> _otherNames = [];
                    List<String> _otherEmails = [];
                    List<String> _paths = [];
                    int max = _list.length;
                    String _oemail = '';
                    for (int k = 0; k < max; k++) {
                      Map<String, dynamic> _m = _list[k].data();
                      print(_m.toString());

                      if (_m['email'][0] == _email) {
                        _oemail = _m['email'][1];
                      } else {
                        _oemail = _m['email'][0];
                      }

                      if (_text.text == null && _text.text == '') {
                        _otherNames.add(_m['names'][_oemail]);
                        _otherEmails.add(_oemail);
                        _paths.add(_list[k].id);
                      } else {
                        String s = _m['names'][_oemail];
                        if (s.contains(_text.text)) {
                          _otherNames.add(_m['names'][_oemail]);
                          _otherEmails.add(_oemail);
                          _paths.add(_list[k].id);
                        }
                      }
                    }

                    max = _otherNames.length;
                    Vibration.vibrate(duration: 1500);
                    print(_otherEmails);
                    print(_otherNames);
                    print('docs');
                    Future.delayed(Duration(milliseconds: 1500)).then((value) {
                      _bloc.activeSink.add(true);
                    });

                    return StreamBuilder<int>(
                      initialData: -1,
                      stream: _bloc.chat,
                      builder: (context, AsyncSnapshot<int> ind) {
                        String _otherName = '';
                        if (ind.data! >= 0) {
                          _otherName = _otherNames[ind.data!];
                        }
                        if (ind.data! == -2) {
                          _otherName = 'type';
                        }
                        return StreamBuilder<bool>(
                          stream: _bloc.active,
                          builder: (context, AsyncSnapshot<bool> activess) {
                            return GestureDetector(
                              onDoubleTap: () {
                                if (activess.data!) {
                                  _text.clear();
                                  _bloc.pageControllSink.add(true);
                                  _bloc.chatSink.add(-1);
                                }
                              },
                              onTap: () {
                                if (activess.data! &&
                                    (ind.data! > -1 || ind.data == -2)) {
                                  _bloc.activeSink.add(false);
                                  if (ind.data! == -2) {
                                    text = true;
                                    _bloc.pageControllSink.add(false);
                                    Vibration.vibrate(duration: 1500);
                                    Future.delayed(Duration(milliseconds: 1500))
                                        .then((value) {
                                      _bloc.activeSink.add(true);
                                    });
                                  } else {
                                    text = false;
                                    _otherEmail = _otherEmails[ind.data!];
                                    _bloc.activeSink.add(false);
                                    _bloc.pageControllSink.add(false);
                                    Vibration.vibrate(duration: 1500);
                                    _path = _paths[ind.data!];
                                    _bloc.pageControllSink.add(false);
                                    print('vibration push');
                                    Future.delayed(Duration(milliseconds: 1500))
                                        .then((value) {
                                      _bloc.activeSink.add(true);
                                      print('tre');
                                    });
                                  }
                                }
                              },
                              onHorizontalDragUpdate: (details) {
                                if (details.delta.dx > 11 && activess.data!) {
                                  print('object');
                                  _bloc.pageSink.add('main');
                                  _bloc.activeSink.add(false);
                                  Vibration.vibrate(duration: 1500);
                                  Future.delayed(Duration(milliseconds: 1500))
                                      .then((value) {
                                    _bloc.activeSink.add(true);
                                  });
                                }
                              },
                              onVerticalDragUpdate: (details) {
                                //up swipe
                                if (details.delta.dy < -11 &&
                                    activess.data! &&
                                    ind.data! < max - 1) {
                                  if (ind.data! == -2 || ind.data! == -1) {
                                    _bloc.activeSink.add(false);
                                    _bloc.chatSink.add(0);
                                    _vibes
                                        .vibrate(_otherNames[0])
                                        .then((value) {
                                      _bloc.activeSink.add(true);
                                    });
                                  } else {
                                    _bloc.activeSink.add(false);
                                    _bloc.chatSink.add(ind.data! + 1);
                                    _vibes
                                        .vibrate(_otherNames[ind.data! + 1])
                                        .then((value) {
                                      _bloc.activeSink.add(true);
                                    });
                                  }
                                }

                                //down swipe
                                else if (details.delta.dy > 11 &&
                                    activess.data! &&
                                    ind.data! > -2) {
                                  _bloc.activeSink.add(false);
                                  if (ind.data! == 0 || ind.data! == -1) {
                                    _bloc.chatSink.add(-2);
                                    _vibes.vibrate('type').then((value) {
                                      _bloc.activeSink.add(true);
                                    });
                                  } else {
                                    _bloc.chatSink.add(ind.data! - 1);
                                    _vibes
                                        .vibrate(_otherNames[ind.data! - 1])
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
                                child: Center(
                                  child: Text(_otherName),
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
          } else if (text == false) {
            return SpecialChatScreen(_path, _name, _email, _otherEmail, _bloc);
          } else {
            return SpecialTextField(_bloc, _morse, _text);
          }
        },
      ),
    );
  }
}
