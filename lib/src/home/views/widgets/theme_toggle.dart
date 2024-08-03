import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:interval/core/common/app/current_theme_mode.dart';
import 'package:interval/core/extensions/context_extensions.dart';
import 'package:interval/core/services/cache_helper.dart';
import 'package:interval/l10n/l10n.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: CurrentThemeMode.instance,
      builder: (_, themeMode, __) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: animation.drive(
                  Tween<Offset>(
                    begin: Offset.zero,
                    end: Offset(0, animation.value),
                  ),
                ),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            key: UniqueKey(),
            onTap: () async {
              ThemeMode newMode;
              switch (themeMode) {
                case ThemeMode.dark:
                  newMode = ThemeMode.light;
                case ThemeMode.light:
                  newMode = ThemeMode.system;
                case ThemeMode.system:
                  newMode = ThemeMode.dark;
              }

              await CacheHelper.instance.cacheThemeMode(newMode);
            },
            child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    size: 30,
                    color: switch (themeMode) {
                      ThemeMode.light => Colors.yellow,
                      ThemeMode.dark => Colors.blueGrey,
                      ThemeMode.system =>
                        context.isDarkMode ? Colors.blueGrey : Colors.yellow,
                    },
                    switch (themeMode) {
                      ThemeMode.light => Icons.light_mode,
                      ThemeMode.dark => Icons.dark_mode,
                      ThemeMode.system => switch (defaultTargetPlatform) {
                          TargetPlatform.iOS => Icons.phone_iphone_rounded,
                          TargetPlatform.android ||
                          TargetPlatform.fuchsia =>
                            Icons.phone_android_rounded,
                          TargetPlatform.linux =>
                            Icons.laptop_chromebook_rounded,
                          TargetPlatform.macOS => Icons.laptop_mac_rounded,
                          TargetPlatform.windows =>
                            Icons.laptop_windows_rounded,
                        },
                    },
                  ),
                  const Gap(3),
                  Text(
                    switch (themeMode) {
                      ThemeMode.dark => context.l10n.themeDark,
                      ThemeMode.light => context.l10n.themeLight,
                      ThemeMode.system => context.l10n.themeSystem,
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
