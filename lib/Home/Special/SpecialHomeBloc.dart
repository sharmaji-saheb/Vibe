import 'dart:async';

import 'package:flutter/material.dart';

class SpecialHomeBloc{
  /*
    *** CONSTRUCTOR ***
  */
  SpecialHomeBloc(){
    _states = StreamController<int>.broadcast();
    _active = StreamController<bool>.broadcast();
    _page = StreamController<String>.broadcast();
    _chat = StreamController<int>.broadcast();
  }

  /*
    *** DECLARATIONS ***
  */
  late final StreamController<int> _states;
  late final StreamController<bool> _active;
  late final StreamController<String> _page;
  late final StreamController<int> _chat;

  /*
    *** GETTERS ***
  */
  Stream<int> get states => _states.stream;
  Stream<bool> get active => _active.stream;
  Stream<String> get page => _page.stream;
  Stream<int> get chat => _chat.stream;

  Sink<int> get statesSink => _states.sink;
  Sink<bool> get activeSink => _active.sink;
  Sink<String> get pageSink => _page.sink;
  Sink<int> get chatSink => _chat.sink;
}