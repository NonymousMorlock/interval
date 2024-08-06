import 'package:flutter/material.dart';
import 'package:interval/core/common/app/current_theme_mode.dart';
import 'package:interval/core/extensions/context_extensions.dart';
import 'package:interval/core/res/media.dart';
import 'package:rive/rive.dart';

class FunTime extends StatelessWidget {
  const FunTime({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CurrentThemeMode.instance,
      builder: (_, themeMode, __) {
        if (themeMode == ThemeMode.dark ||
            (themeMode == ThemeMode.system && context.isDarkMode)) {
          return const RiveAnimation.asset(
            Media.funTimeDark$rive,
            useArtboardSize: true,
          );
        }
        return const RiveAnimation.asset(
          Media.funTime$rive,
          useArtboardSize: true,
        );
      },
    );
  }
}
