import 'package:flutter/material.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:vibration/vibration.dart';

class MainPageHomeSpecial extends StatelessWidget {
  late final SpecialHomeBloc _bloc;
  MainPageHomeSpecial(SpecialHomeBloc _b){
    _bloc = _b;
  }
  @override
  Widget build(BuildContext context) {
    final Vibes _vibes = Vibes();
    final List<String> states = ['search', '', 'chats', 'add', 'logout'];
    return StreamBuilder<int>(
      initialData: 1,
      stream: _bloc.states,
      builder: (context, AsyncSnapshot<int> snapshot) {
        int index = snapshot.data!;
        return StreamBuilder<bool>(
          initialData: true,
          stream: _bloc.active,
          builder: (context, AsyncSnapshot<bool> snap) {
            return GestureDetector(
              onVerticalDragUpdate: (details) {
                //up swipe
                if (details.delta.dy < -11 && index < 4 && snap.data!) {
                  print('up');
                  print(snapshot.data!);
                  _bloc.activeSink.add(false);
                  if (index == 0) {
                    _bloc.statesSink.add(index + 2);
                    _vibes.vibrate(states[index + 2][0]).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  } else {
                    _bloc.statesSink.add(index + 1);
                    _vibes.vibrate(states[index + 1][0]).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                }

                //down swipe
                if (details.delta.dy > 11 && index > 0 && snap.data!) {
                  print('1');
                  _bloc.activeSink.add(false);
                  if (index == 2) {
                    _bloc.statesSink.add(index - 2);
                    _vibes.vibrate(states[index - 2][0]).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  } else {
                    print('object');
                    _bloc.statesSink.add(index - 1);
                    _vibes.vibrate(states[index - 1][0]).then((value) {
                      _bloc.activeSink.add(true);
                    });
                  }
                }
              },
              onTap: () {
                if (index == 2 && snap.data!) {
                  _bloc.activeSink.add(false);
                  _bloc.pageSink.add('chats');
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