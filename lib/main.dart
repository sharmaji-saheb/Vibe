import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minor/VibeAndMorse/vibe.dart';
import 'package:minor/app/App.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

Future<void> main() async {
  //initialize firebase

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //run app
  SharedPreferences.getInstance().then((value) {
    value.setString('mode', 'special').then((value) {
      runApp(App());
    });
  });
}

// Future<void> main() async {
//   runApp(trial());
// }

// class trial extends StatefulWidget {
//   const trial({Key? key}) : super(key: key);

//   @override
//   _trialState createState() => _trialState();
// }

// class _trialState extends State<trial> {
//   Vibes _vibes = Vibes();
//   Widget build(BuildContext context) {
//     _viberrrrrrrrrr();
//     return MaterialApp(
//       home: Container(),
//     );
//   }

//   _viberrrrrrrrrr() async {
//     print('object');
//     await Vibration.vibrate(duration: 1000).then((value) {print('object1');});
//   }
// }
