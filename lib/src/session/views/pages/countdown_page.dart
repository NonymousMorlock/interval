import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/enums/session_state.dart';
import 'package:interval/src/session/views/app/provider/time_ticker_controller.dart';
import 'package:interval/src/session/views/app/provider/timer_animation_controller.dart';
import 'package:interval/src/session/views/widgets/time_ticker.dart';
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
  SessionState _activityState = SessionState.IDLE;
  late TimeTickerController _mainTimeController;
  late TimeTickerController _workTimeController;
  TimeTickerController? _restTimeController;

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

  void mainControllerListener() {
    final controller = _mainTimeController;
    if (controller.remainingTime <= 0 && !widget.session.prioritizeOverlap) {
      if (_activityState == SessionState.WORKING) {
        context.read<TimerAnimationController>().stop();
      }
      // TODO(stopAll): Do everything necessary for post-completion
    }
  }

  void workControllerListener() {
    final controller = _workTimeController;
    final isWorking = _activityState == SessionState.WORKING;
    if (controller.remainingTime <= 0 &&
        _mainTimeController.remainingTime > 0 &&
        _activityState != SessionState.RESTING) {
      if (widget.session.hasRestTime) {
        _restTimeController?.startTicker();
      } else {
        controller.startTicker();
      }
    } else if (controller.remainingTime <= 0 &&
        _mainTimeController.remainingTime <= 0 &&
        isWorking) {
      context.read<TimerAnimationController>().stop();
    } else if (isWorking && !controller.isRunning) {
      setState(() {
        _activityState = SessionState.IDLE;
      });
    } else if (_activityState != SessionState.WORKING && controller.isRunning) {
      setState(() {
        _activityState = SessionState.WORKING;
      });
    }
  }

  void restControllerListener() {
    final controller = _restTimeController!;
    final isResting = _activityState == SessionState.RESTING;
    if (controller.remainingTime <= 0 &&
        _mainTimeController.remainingTime > 0 &&
        _activityState != SessionState.WORKING) {
      _workTimeController.startTicker();
    } else if (isResting && !controller.isRunning) {
      setState(() {
        _activityState = SessionState.IDLE;
      });
    } else if (_activityState != SessionState.RESTING && controller.isRunning) {
      setState(() {
        _activityState = SessionState.RESTING;
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Gap(30),
          Text('Main Time', style: Theme.of(context).textTheme.labelLarge),
          TimeTicker(
            controller: _mainTimeController,
            onDispose: () {
              _mainTimeController.removeListener(mainControllerListener);
            },
          ),
          const Gap(30),
          Text(
            switch (_activityState) {
              SessionState.WORKING => 'Work Time',
              SessionState.RESTING => 'Rest Time',
              _ => ''
            },
            style: Theme.of(context).textTheme.labelLarge,
          ),
          Visibility(
            visible: _activityState == SessionState.WORKING,
            maintainState: true,
            child: TimeTicker(
              controller: _workTimeController,
              onDispose: () {
                _workTimeController.removeListener(workControllerListener);
              },
            ),
          ),
          Visibility(
            visible: _activityState == SessionState.RESTING,
            maintainState: true,
            child: TimeTicker(
              controller: _restTimeController!,
              onDispose: () {
                _restTimeController!.removeListener(restControllerListener);
              },
            ),
          ),
          const Gap(40),
          ElevatedButton(
            onPressed: () {
              _workTimeController.startTicker();
              _mainTimeController.startTicker();
            },
            child: const Text('Start'),
          ),
          const Expanded(
            child: Placeholder(
              color: Colors.blue,
              child: Center(
                child: Text('Animation', style: TextStyle(fontSize: 32)),
              ),
            ),
          ),
          const Expanded(
            child: Placeholder(
              color: Colors.green,
              child: Center(
                child: Text('Controls', style: TextStyle(fontSize: 32)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
