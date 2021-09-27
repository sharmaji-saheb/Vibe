import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/*
  '''
    File for all fonts and themes to be used in thi app
  '''
*/
class ThemeFonts {
  TextStyle scaffoldTitle(BuildContext context) {
    double _size = MediaQuery.of(context).size.height * 0.1 * 0.45;
    return GoogleFonts.patuaOne(
      color: Colors.white,
      fontSize: _size,
    );
  }

  TextStyle loginOptionButtons() {
    double _size = 20;
    return GoogleFonts.ubuntu(
      color: Colors.white,
      fontSize: _size,
      fontWeight: FontWeight.w700
    );
  }

  TextStyle loginText(){
    return GoogleFonts.ropaSans(
      fontSize: 22,
      color: Colors.white,
    );
  }

  TextStyle loginButton(int _size){
    return GoogleFonts.ubuntu(
      fontSize: _size*0.8,
      color: Colors.white,
    );
  }
}
