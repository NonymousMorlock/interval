import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  bool get isDarkMode {
    return MediaQuery.platformBrightnessOf(this) == Brightness.dark;
  }

  ThemeData get theme => Theme.of(this);
}
