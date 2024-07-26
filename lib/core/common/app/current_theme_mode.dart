import 'package:flutter/material.dart';

class CurrentThemeMode extends ValueNotifier<ThemeMode> {
  CurrentThemeMode._internal(super._value);

  static final CurrentThemeMode instance =
      CurrentThemeMode._internal(ThemeMode.system);

  void changeThemeMode(ThemeMode mode) {
    if (value != mode) value = mode;
  }
}
