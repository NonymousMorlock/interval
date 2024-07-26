import 'package:flutter/material.dart';
import 'package:interval/core/common/app/current_theme_mode.dart';
import 'package:interval/core/extensions/string_extensions.dart';
import 'package:interval/core/extensions/theme_mode_extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  CacheHelper._internal();

  static final CacheHelper instance = CacheHelper._internal();

  static const _themeModeKey = 'theme-mode';

  late SharedPreferences _prefs;

  bool _initialized = false;

  void init(SharedPreferences prefs) {
    if (_initialized) return;
    _prefs = prefs;
    _initialized = true;
  }

  Future<void> cacheThemeMode(ThemeMode themeMode) async {
    await _prefs.setString(_themeModeKey, themeMode.stringValue);
    CurrentThemeMode.instance.changeThemeMode(themeMode);
  }

  ThemeMode getThemeMode() {
    final themeModeStringValue = _prefs.getString(_themeModeKey);
    final themeMode = themeModeStringValue?.toThemeMode ?? ThemeMode.system;
    CurrentThemeMode.instance.changeThemeMode(themeMode);
    return themeMode;
  }
}
