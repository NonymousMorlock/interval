import 'package:flutter/material.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/l10n/l10n.dart';

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
          _ => ListView.builder(
              itemCount: intervals.length,
              itemBuilder: (_, index) {
                final interval = intervals[index];
                return ListTile(
                  title: Text(interval.title),
                  subtitle: interval.description == null
                      ? null
                      : Text(interval.description!),
                );
              },
            ),
        },
      ),
    );
  }
}
