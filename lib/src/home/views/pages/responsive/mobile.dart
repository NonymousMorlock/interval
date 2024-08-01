import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/l10n/l10n.dart';
import 'package:interval/src/home/views/widgets/interval_session_tile.dart';

class HomeMobileView extends StatelessWidget {
  const HomeMobileView({required this.intervals, super.key});

  final List<IntervalSession> intervals;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: switch (intervals.isEmpty) {
          true => Text(
              context.l10n.homeEmptyCacheMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          _ => ListView.separated(
              itemCount: intervals.length,
              separatorBuilder: (_, __) => const Gap(10),
              itemBuilder: (_, index) {
                return IntervalSessionTile(intervals[index]);
              },
            ),
        },
      ),
    );
  }
}
