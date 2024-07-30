import 'package:flutter/material.dart';
import 'package:interval/core/enums/overlap.dart';
import 'package:interval/core/extensions/duration_extensions.dart';

class OverlapMessage extends TextSpan {
  const OverlapMessage({
    required this.overlap,
    required this.overlapDuration,
  });

  final Overlap overlap;
  final Duration overlapDuration;

  @override
  List<InlineSpan>? get children => [
        const TextSpan(
          text: 'Message: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: 'By the time your overall activity time elapses, you will '
              'still have ${overlapDuration.timeInWords} left to',
        ),
        TextSpan(text: "${overlap == Overlap.WORK ? ' work.' : ' rest.'}\n\n"),
        const TextSpan(
          text: 'Prioritize Overlap: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const TextSpan(text: '\n- '),
        const TextSpan(
          text: 'On: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: 'The timer will continue running until you finish the '
              "remaining ${overlap == Overlap.WORK ? 'work' : 'rest'} time.\n",
        ),
        const TextSpan(text: '- '),
        const TextSpan(
          text: 'Off: ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        TextSpan(
          text: 'The timer will stop exactly at the end of the overall '
              'activity time[Main Duration], and you will not complete the '
              "remaining ${overlap == Overlap.WORK ? 'work' : 'rest'} time.",
        ),
      ];
}
