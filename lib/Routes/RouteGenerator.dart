import 'package:flutter/material.dart';
import 'package:minor/ChatRoom/ChatRoom.dart';
import 'package:minor/Landing/LandingPage.dart';
import 'package:minor/Login/EmailLogin.dart';
import 'package:minor/Login/EmailRegister.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      //Landing Page
      case '/':
        return MaterialPageRoute(builder: (_) => LandingPage());

      //Email login page
      case '/EmailLogin':
        return MaterialPageRoute(builder: (_) => EmailLogin());

      //Email register page
      case '/EmailLogin/EmailRegister':
        return MaterialPageRoute(builder: (_) => EmailRegister());

      case '/ChatRoom':
        { List? str = args as List?;
          return MaterialPageRoute(builder: (_) => ChatRoom(args: args,));}

      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        body: Text('404'),
      );
    });
  }
}
