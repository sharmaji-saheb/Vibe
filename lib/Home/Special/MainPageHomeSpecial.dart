import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class MainPageHomeSpecial extends StatelessWidget {
  late final SpecialHomeBloc _bloc;
  MainPageHomeSpecial(SpecialHomeBloc _b) {
    _bloc = _b;
  }
  @override
  Widget build(BuildContext context) {
    final Vibes _vibes = Vibes();
    final List<String> states = ['', 'chats', 'add', 'mode', 'logout'];
    return StreamBuilder<int>(
      initialData: 0,
      stream: _bloc.states,
      builder: (context, AsyncSnapshot<int> snapshot) {
        int index = snapshot.data!;
        return StreamBuilder<bool>(
          initialData: true,
          stream: _bloc.active,
          builder: (context, AsyncSnapshot<bool> snap) {
            print(snap.data);
            return GestureDetector(
              onVerticalDragUpdate: (details) {
                //up swipe
                if (details.delta.dy < -11 && index < 4 && snap.data!) {
                  print('up');
                  print(snapshot.data!);
                  _bloc.activeSink.add(false);

                  _bloc.statesSink.add(index + 1);
                  _vibes.vibrate(states[index + 1]).then((value) {
                    _bloc.activeSink.add(true);
                  });
                }

                //down swipe
                if (details.delta.dy > 11 && index > 1 && snap.data!) {
                  print('1');
                  _bloc.activeSink.add(false);

                  print('object');
                  _bloc.statesSink.add(index - 1);
                  _vibes.vibrate(states[index - 1]).then((value) {
                    _bloc.activeSink.add(true);
                  });
                }
              },
              onTap: () {
                if (index == 1 && snap.data!) {
                  _bloc.activeSink.add(false);
                  _bloc.pageSink.add('chats');
                }
                if (index == 2) {
                  _bloc.activeSink.add(false);
                  _bloc.pageSink.add('add');
                  Vibration.vibrate(duration: 1500);
                  Future.delayed(Duration(milliseconds: 1500)).then((value) {
                    _bloc.activeSink.add(true);
                  });
                }
                if (index == 4 && snap.data!) {
                  _bloc.signOut();
                }
              },
              onDoubleTap: () {
                if (snap.data! && snapshot.data! == 3) {
                  _bloc.activeSink.add(false);
                  Vibration.vibrate(duration: 1500);
                  Future.delayed(Duration(milliseconds: 1500)).then((value) {
                    SharedPreferences.getInstance().then((value) {
                      value.setString('mode', 'normal');
                      Future.delayed(Duration(milliseconds: 500)).then((value) {
                        _vibes.vibrate('restart the app').then((value) {
                          _bloc.activeSink.add(true);
                        });
                      });
                    });
                  });
                }
              },
              child: Container(
                color: Color(0xff292B2F),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: Text(states[snapshot.data!]),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
