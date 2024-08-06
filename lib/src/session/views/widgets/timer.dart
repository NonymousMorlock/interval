import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interval/core/common/app/app_state.dart';
import 'package:interval/core/res/media.dart';
import 'package:interval/src/session/views/app/provider/timer_animation_controller.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  RiveFile? _timerFile;

  @override
  void initState() {
    super.initState();
    preload();
  }

  void preload() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => AppState.instance.startLoading(),
    );
    rootBundle.load(Media.timer$rive).then((data) {
      setState(() {
        _timerFile = RiveFile.import(data);
      });
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => AppState.instance.stopLoading(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_timerFile == null) return const SizedBox.shrink();
    return RiveAnimation.direct(
      key: UniqueKey(),
      _timerFile!,
      useArtboardSize: true,
      alignment: Alignment.center,
      onInit: context.read<TimerAnimationController>().onInit,
    );
  }
}
