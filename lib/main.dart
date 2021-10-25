import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:minor/app/App.dart';

Future<void> main() async {
  //initialize firebase
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //run app
  runApp(App());
}
