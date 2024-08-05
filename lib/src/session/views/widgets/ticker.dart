import 'dart:async';

import 'package:flutter/material.dart';
import 'package:interval/core/extensions/duration_extensions.dart';

class Ticker extends StatefulWidget {
  const Ticker(this.durationMilliseconds, {super.key});

  final int durationMilliseconds;

  @override
  State<Ticker> createState() => _TickerState();
}

class _TickerState extends State<Ticker> {
  late DateTime _endTime;
  Timer? _timer;

  bool renderMilliseconds = false;
  Duration rate = const Duration(seconds: 1);

  @override
  void initState() {
    super.initState();
    final totalDuration = Duration(milliseconds: widget.durationMilliseconds);
    _endTime = DateTime.now().add(totalDuration);
    if (totalDuration.millisecondsPart > 0) {
      renderMilliseconds = true;
      rate = const Duration(milliseconds: 16);
    }
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(rate, (timer) {
      final remainingTime = _remainingTime;
      if (remainingTime <= 0) {
        _timer?.cancel();
      }
      setState(() {});
    });
  }

  int get _remainingTime {
    final currentTime = DateTime.now();
    final difference = _endTime.difference(currentTime);
    if(difference.isNegative) {
      return 0;
    }
    return renderMilliseconds
        ? difference.inMilliseconds
        : difference.inSeconds;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: TickerPainter(
        remainingTime: _remainingTime,
        renderMilliseconds: renderMilliseconds,
      ),
      child: Container(),
    );
  }
}

class TickerPainter extends CustomPainter {
  TickerPainter({
    required this.remainingTime,
    required this.renderMilliseconds,
  }) {
    _textPainter = TextPainter(
      text: TextSpan(
        text: _formatTime(
          remainingTime: remainingTime,
          renderMilliseconds: renderMilliseconds,
        ),
        style: const TextStyle(color: Colors.white, fontSize: 30),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
  }

  final int remainingTime;
  final bool renderMilliseconds;
  late final TextPainter _textPainter;

  @override
  void paint(Canvas canvas, Size size) {
    _textPainter.paint(canvas, Offset.zero);
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
