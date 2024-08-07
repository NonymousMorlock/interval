import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/enums/session_state.dart';
import 'package:interval/src/session/views/app/provider/time_ticker_controller.dart';
import 'package:interval/src/session/views/app/provider/timer_animation_controller.dart';
import 'package:interval/src/session/views/widgets/controls.dart';
import 'package:interval/src/session/views/widgets/fun_time.dart';
import 'package:interval/src/session/views/widgets/time_ticker.dart';
import 'package:interval/src/session/views/widgets/timer.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class CountdownPage extends StatefulWidget {
  const CountdownPage(this.session, {super.key});

  static const path = '/countdown';

  final IntervalSession session;

  @override
  State<CountdownPage> createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  SessionState _sessionState = SessionState.IDLE;
  late TimeTickerController _mainTimeController;
  late TimeTickerController _workTimeController;
  TimeTickerController? _restTimeController;
  final _stopTrigger = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    _mainTimeController = TimeTickerController(
      Duration(microseconds: widget.session.mainTime).inMilliseconds,
    )..addListener(mainControllerListener);
    _workTimeController = TimeTickerController(
      Duration(microseconds: widget.session.workTime).inMilliseconds,
    )..addListener(workControllerListener);
    if (widget.session.hasRestTime) {
      _restTimeController = TimeTickerController(
        Duration(microseconds: widget.session.restTime).inMilliseconds,
      )..addListener(restControllerListener);
    }
  }

  /// Perform the necessary actions to stop the session
  void stop() {
    _stopTrigger.value = true;
    _sessionState = SessionState.IDLE;
  }

  void mainControllerListener() {
    final controller = _mainTimeController;
    if (controller.remainingTime <= 0 && !widget.session.prioritizeOverlap) {
      if (_sessionState == SessionState.WORKING) {
        context.read<TimerAnimationController>().stop();
      }
      stop();
    }
  }

  void workControllerListener() {
    final controller = _workTimeController;
    final isWorking = _sessionState == SessionState.WORKING;
    final timerAnimationController = context.read<TimerAnimationController>();
    if (controller.remainingTime <= 0 &&
        _mainTimeController.remainingTime > 0 &&
        _sessionState != SessionState.RESTING) {
      if (widget.session.hasRestTime) {
        _restTimeController?.startTicker();
        timerAnimationController.pause();
      } else {
        controller.startTicker();
      }
    } else if (controller.remainingTime <= 0 &&
        _mainTimeController.remainingTime <= 0 &&
        isWorking) {
      timerAnimationController.stop();
      stop();
    } else if (isWorking && !controller.isRunning && !controller.isPaused) {
      setState(() {
        _sessionState = SessionState.IDLE;
      });
      timerAnimationController.pause();
    } else if (_sessionState != SessionState.WORKING && controller.isRunning) {
      setState(() {
        _sessionState = SessionState.WORKING;
        timerAnimationController.start();
      });
    }
  }

  void restControllerListener() {
    final controller = _restTimeController!;
    final isResting = _sessionState == SessionState.RESTING;
    if (controller.remainingTime <= 0 &&
        _mainTimeController.remainingTime > 0 &&
        _sessionState != SessionState.WORKING) {
      _workTimeController.startTicker();
    } else if (controller.remainingTime <= 0 &&
        _mainTimeController.remainingTime <= 0 &&
        isResting) {
      stop();
    } else if (isResting && !controller.isRunning && !controller.isPaused) {
      setState(() {
        _sessionState = SessionState.IDLE;
      });
    } else if (_sessionState != SessionState.RESTING && controller.isRunning) {
      setState(() {
        _sessionState = SessionState.RESTING;
      });
    }
  }

  @override
  void dispose() {
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.session.title),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Gap(30),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Main Time',
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  TimeTicker(
                    controller: _mainTimeController,
                    onDispose: () {
                      _mainTimeController
                          .removeListener(mainControllerListener);
                    },
                  ),
                  const Gap(30),
                  Text(
                    switch (_sessionState) {
                      SessionState.WORKING => 'Work Time',
                      SessionState.RESTING => 'Rest Time',
                      _ => ''
                    },
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Visibility(
                    visible: _sessionState == SessionState.WORKING,
                    maintainState: true,
                    child: TimeTicker(
                      controller: _workTimeController,
                      onDispose: () {
                        _workTimeController
                            .removeListener(workControllerListener);
                      },
                    ),
                  ),
                  Visibility(
                    visible: _sessionState == SessionState.RESTING,
                    maintainState: true,
                    child: TimeTicker(
                      controller: _restTimeController!,
                      onDispose: () {
                        _restTimeController!.removeListener(
                          restControllerListener,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Gap(40),
          Visibility(
            visible: _sessionState == SessionState.RESTING,
            maintainState: true,
            child: const FunTime(),
          ),
          Visibility(
            visible: _sessionState != SessionState.RESTING,
            maintainState: true,
            maintainAnimation: true,
            child: const Timer(),
          ),
          Expanded(
            flex: 3,
            child: Controls(
              stopTrigger: _stopTrigger,
              onStop: () {
                setState(() {
                  _sessionState = SessionState.IDLE;
                });
                _mainTimeController.stopAndReset();
                if (_workTimeController.isRunning) {
                  context.read<TimerAnimationController>().reset();
                  _workTimeController.stopAndReset();
                } else if (_restTimeController?.isRunning ?? false) {
                  _restTimeController!.stopAndReset();
                }
              },
              onPause: () {
                final workRemaining = _workTimeController.remainingTime;
                final restRemaining = _restTimeController?.remainingTime;
                final mainRemaining = _mainTimeController.remainingTime;
                _mainTimeController.pauseTicker(remainingTime: mainRemaining);
                if (_workTimeController.isRunning) {
                  _workTimeController.pauseTicker(
                    remainingTime: workRemaining,
                  );
                  context.read<TimerAnimationController>().pause();
                } else if (_restTimeController?.isRunning ?? false) {
                  _restTimeController!.pauseTicker(
                    remainingTime: restRemaining,
                  );
                }
              },
              onPlay: () {
                _workTimeController.startTicker();
                _mainTimeController.startTicker();
              },
              onResume: () {
                context.read<TimerAnimationController>().start();
                _mainTimeController.resumeTicker();
                if (_workTimeController.isPaused) {
                  _workTimeController.resumeTicker();
                } else if (_restTimeController?.isPaused ?? false) {
                  _restTimeController!.resumeTicker();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
