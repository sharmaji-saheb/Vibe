import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class ChatPageSpecial extends StatelessWidget {
  ChatPageSpecial(SpecialHomeBloc bloc) {
    _bloc = bloc;
  }
  final Vibes _vibes = Vibes();
  late final SpecialHomeBloc _bloc;
  Widget build(BuildContext context) {
    return SafeArea(
        child: FutureBuilder<SharedPreferences>(
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

        String _email = shared.data!.getString('email')!;
        return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection('chatRooms')
              .where('email', arrayContains: _email)
              .get(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> queryss) {
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
            int max = _list.length;
            for (int k = 0; k < max; k++) {
              Map<String, dynamic> _m = _list[k].data();
              String _oemail = '';
              if (_m['email'][0] == _email) {
                _oemail = _m['email'][1];
              } else {
                _oemail = _m['email'][0];
              }

              _otherNames.add(_m['names'][_oemail]);
            }
            Vibration.vibrate(duration: 1500);
            Future.delayed(Duration(milliseconds: 1500)).then((value) {
              _bloc.activeSink.add(true);
            });

            return StreamBuilder<int>(
              initialData: -1,
              stream: _bloc.chat,
              builder: (context, AsyncSnapshot<int> ind) {
                String _otherName = '';
                if (ind.data! != -1) {
                  _otherName = _otherNames[ind.data!];
                }
                return StreamBuilder<bool>(
                  stream: _bloc.active,
                  builder: (context, AsyncSnapshot<bool> activess) {
                    return GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        if (details.delta.dx > 11 && activess.data!) {
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
                          _bloc.activeSink.add(false);
                          _bloc.chatSink.add(ind.data! + 1);
                          _vibes
                              .vibrate(_otherNames[ind.data! + 1])
                              .then((value) {
                            _bloc.activeSink.add(true);
                          });
                        } else if (details.delta.dy > 11 &&
                            activess.data! &&
                            ind.data! > 0) {
                          _bloc.activeSink.add(false);
                          _bloc.chatSink.add(ind.data! - 1);
                          _vibes
                              .vibrate(_otherNames[ind.data! - 1])
                              .then((value) {
                            _bloc.activeSink.add(true);
                          });
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
    ));
  }
}
