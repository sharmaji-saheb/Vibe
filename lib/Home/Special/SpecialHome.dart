import 'package:flutter/material.dart';
import 'package:minor/Home/Special/ChatsPageSpecial.dart';
import 'package:minor/Home/Special/MainPageHomeSpecial.dart';
import 'package:minor/Home/Special/SpecialAdd.dart';
import 'package:minor/Home/Special/SpecialHomeBloc.dart';
import 'package:minor/VibeAndMorse/vibe.dart';

class SpecialHome extends StatefulWidget {
  const SpecialHome({Key? key}) : super(key: key);

  @override
  _SpecialHomeState createState() => _SpecialHomeState();
}

class _SpecialHomeState extends State<SpecialHome>
    with AutomaticKeepAliveClientMixin {
  final Vibes _vibes = Vibes();
  @override
  bool get wantKeepAlive => true;
  Widget build(BuildContext context) {
    final SpecialHomeBloc _bloc = SpecialHomeBloc(context);
    return SafeArea(
      child: Center(
        child: StreamBuilder<String>(
          stream: _bloc.page,
          initialData: 'main',
          builder: (context, AsyncSnapshot<String> ss) {
            if (ss.data == 'main') {
              print('main');
              return MainPageHomeSpecial(_bloc);
            }
            if (ss.data == 'chats') {
              return ChatPageSpecial(_bloc);
            }

            if (ss.data == 'add') {
              return SpecialAdd(_bloc);
            }

            return Text('data');
          },
        ),
      ),
    );
  }
}
