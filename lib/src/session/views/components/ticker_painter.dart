import 'package:flutter/material.dart';
import 'package:interval/core/extensions/duration_extensions.dart';

class TickerPainter extends CustomPainter {
  TickerPainter({
    required this.remainingTime,
    required this.renderMilliseconds,
    this.style,
  }) {
    _textPainter = TextPainter(
      text: TextSpan(
        text: _formatTime(
          remainingTime: remainingTime,
          renderMilliseconds: renderMilliseconds,
        ),
        style: style,
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  final int remainingTime;
  final bool renderMilliseconds;
  late final TextPainter _textPainter;
  final TextStyle? style;

  @override
  void paint(Canvas canvas, Size size) {
    _textPainter.paint(
      canvas,
      Offset(
        (size.width / 2) - (_textPainter.width / 2),
        (size.height / 2) - (_textPainter.height / 2),
      ),
    );
  }

  String _formatTime({
    required int remainingTime,
    required bool renderMilliseconds,
  }) {
    final duration = renderMilliseconds
        ? Duration(milliseconds: remainingTime)
        : Duration(seconds: remainingTime);

    final hours = duration.hoursPart;
    final minutes = duration.minutesPart;
    final seconds = duration.secondsPart;
    final milliseconds = duration.millisecondsPart;

    final stringBuilder = StringBuffer();
    if (hours > 0) {
      stringBuilder.write('${hours.toString().padLeft(2, '0')}:');
    }
    stringBuilder
      ..write('${minutes.toString().padLeft(2, '0')}:')
      ..write(seconds.toString().padLeft(2, '0'));
    if (renderMilliseconds) {
      stringBuilder.write('.${milliseconds.toString().padLeft(3, '0')}');
    }
    return stringBuilder.toString();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
