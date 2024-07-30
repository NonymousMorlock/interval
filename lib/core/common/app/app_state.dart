// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';

class AppState {
  AppState._internal();

  static final AppState instance = AppState._internal();

  ValueNotifier<$State> current = ValueNotifier<$State>($State.IDLE);
  ValueNotifier<$State> previous = ValueNotifier<$State>($State.IDLE);

  void update($State state) {
    if (current.value != state) {
      previous.value = current.value;
      current.value = state;
    }
  }

  void resetCurrent() {
    current.value = $State.IDLE;
  }

  void startLoading() {
    update($State.LOADING);
  }

  void stopLoading() {
    update($State.IDLE);
  }
}

enum $State { IDLE, LOADING }
