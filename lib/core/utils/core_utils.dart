import 'package:flutter/material.dart';
import 'package:flutter_platform_alert/flutter_platform_alert.dart';
import 'package:interval/core/extensions/context_extensions.dart';

abstract class CoreUtils {
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColour,
    Color? textColour,
    SnackBarAction? action,
    Duration? duration,
    bool? showCloseIcon,
  }) {
    final snackBar = SnackBar(
      backgroundColor: backgroundColour ?? context.theme.primaryColor,
      action: action,
      duration: duration ?? const Duration(milliseconds: 4000),
      showCloseIcon: showCloseIcon,
      closeIconColor: textColour ?? Colors.white,
      behavior: SnackBarBehavior.floating,
      content: Text(
        message,
        style: TextStyle(color: textColour ?? Colors.white),
      ),
    );

    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Future<void> showErrorAlert({
    required String message,
  }) async {
    await FlutterPlatformAlert.playAlertSound();
    await FlutterPlatformAlert.showAlert(
      windowTitle: 'Error',
      text: message,
      iconStyle: IconStyle.error,
    );
  }
}
