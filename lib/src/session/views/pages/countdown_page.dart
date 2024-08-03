import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/src/session/views/app/provider/timer_animation_controller.dart';
import 'package:interval/src/session/views/widgets/timer.dart';
import 'package:provider/provider.dart';

class CountdownPage extends StatelessWidget {
  const CountdownPage(this.session, {super.key});

  static const path = '/countdown';

  final IntervalSession session;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(session.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Flexible(child: Timer()),
            const Gap(16),
            ElevatedButton(
              onPressed: context.read<TimerAnimationController>().start,
              child: const Text('Start'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: context.read<TimerAnimationController>().pause,
              child: const Text('Pause'),
            ),
            const Gap(8),
            ElevatedButton(
              onPressed: context.read<TimerAnimationController>().reset,
              child: const Text('Reset'),
            ),
          ],
        ),
      ),
    );
  }
}
