import 'package:flutter/material.dart';
import 'package:interval/core/common/app/current_theme_mode.dart';
import 'package:interval/counter/counter.dart';
import 'package:interval/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CurrentThemeMode.instance,
      builder: (context, themeMode, __) {
        return MaterialApp(
          themeMode: themeMode,
          theme: ThemeData(
            colorScheme: const ColorScheme(
              primary: Color(0xFF0D47A1),
              primaryContainer: Color(0xFF5472D3),
              secondary: Color(0xFFFFC107),
              secondaryContainer: Color(0xFFFFF350),
              surface: Colors.white,
              error: Colors.red,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onSurface: Colors.black,
              onError: Colors.white,
              brightness: Brightness.light,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFF212121)),
              bodyMedium: TextStyle(color: Color(0xFF212121)),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: const ColorScheme(
              primary: Color(0xFF0D47A1),
              primaryContainer: Color(0xFF5472D3),
              secondary: Color(0xFFFFC107),
              secondaryContainer: Color(0xFFFFF350),
              surface: Color(0xFF1E1E1E),
              error: Colors.red,
              onPrimary: Colors.white,
              onSecondary: Colors.black,
              onSurface: Colors.white,
              onError: Colors.black,
              brightness: Brightness.dark,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
              bodyMedium: TextStyle(color: Color(0xFFB0B0B0)),
            ),
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const CounterPage(),
        );
      },
    );
  }
}
