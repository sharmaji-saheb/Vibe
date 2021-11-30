import 'package:flutter/cupertino.dart';
import 'package:vibration/vibration.dart';

class Vibes{
  Future<void> vibrate(String str) async {
    for(var i = 0; i<str.length; i++){
      vibe(str[i]);
      print("vibed");
      await Future.delayed(Duration(milliseconds: 1500));
    }
  }

  Future<void> vibe(String letter)async{
    switch(letter){
      case 'a':{
        await a();
        break;
      }

      case 'b':{
        await b();
        break;
      }

      case 'c':{
        await c();
        break;
      }

      case 'd':{
        await d();
        break;
      }

      case 'e':{
        await e();
        break;
      }

      case 'f':{
        await f();
        break;
      }

      case 'g':{
        await g();
        break;
      }

      case 'h':{
        await h();
        break;
      }

      case 'i':{
        await i();
        break;
      }

      case 'j':{
        await j();
        break;
      }

      case 'k':{
        await k();
        break;
      }

      case 'l':{
        await l();
        break;
      }

      case 'm':{
        await m();
        break;
      }

      case 'n':{
        await n();
        break;
      }

      case 'o':{
        await o();
        break;
      }

      case 'p':{
        await p();
        break;
      }

      case 'q':{
        await q();
        break;
      }

      case 'r':{
        await r();
        break;
      }

      case 's':{
        await s();
        break;
      }

      case 't':{
        await t();
        break;
      }

      case 'u':{
        await u();
        break;
      }

      case 'v':{
        await v();
        break;
      }

      case 'w':{
        await w();
        break;
      }

      case 'x':{
        await x();
        break;
      }

      case 'y':{
        await y();
        break;
      }

      case 'z':{
        await z();
        break;
      }

      case ' ':{
        await Future.delayed(Duration(seconds: 1));
        break;
      }

      default:
        break;
    }
  }

  Future<void> wrongVibe()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 150));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 150));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> a()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> b()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> c()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 150));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> d()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
  }

  Future<void> e()async{
    await Vibration.vibrate(duration: 50);
  }

  Future<void> f()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> g()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 300));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> h()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> i()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
  }

  Future<void> j()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> k()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 300));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> l()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 50);  
  }

  Future<void> m()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> n()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> o()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> p()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> q()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> r()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> s()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 50);
  }

  Future<void> t()async{
    await Vibration.vibrate(duration: 300);
  }

  Future<void> u()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> v()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> w()async{
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> x()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
  }

  Future<void> y()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
  }
  
  Future<void> z()async{
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 200);
    await Future.delayed(Duration(milliseconds: 350));
    await Vibration.vibrate(duration: 50);
    await Future.delayed(Duration(milliseconds: 200)); 
    await Vibration.vibrate(duration: 50);
  }
}

class VibrateWord{
  final vibe = Vibes();

  void vibrateWords(String word)async{
    for(int i=0; i<word.length; i++){
      vibe.vibe(word[i]);
      print("vibed");
      await Future.delayed(Duration(milliseconds: 1500));
    }
  }
}