import 'package:flutter/material.dart';

class SpecialTextField extends StatefulWidget {
  SpecialTextField({@required this.controller});
  late final TextEditingController? controller;
  _SpecialTextFieldState createState() =>
      _SpecialTextFieldState(controller: controller);
}

class _SpecialTextFieldState extends State<SpecialTextField> {
  _SpecialTextFieldState({@required this.controller});
  late final TextEditingController? controller;

  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        child: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
    );
  }
}
