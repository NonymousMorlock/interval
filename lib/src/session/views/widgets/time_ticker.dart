import 'package:flutter/material.dart';
import 'package:interval/core/extensions/context_extensions.dart';
import 'package:interval/src/session/views/app/provider/time_ticker_controller.dart';
import 'package:interval/src/session/views/components/ticker_painter.dart';

class TimeTicker extends StatefulWidget {
  const TimeTicker({required this.controller, this.onDispose, super.key});

  final TimeTickerController controller;
  final VoidCallback? onDispose;

  @override
  State<TimeTicker> createState() => _TimeTickerState();
}

class _TimeTickerState extends State<TimeTicker>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    widget.controller.init(this);
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, __) {
        return Center(
          child: CustomPaint(
            painter: TickerPainter(
              remainingTime: widget.controller.remainingTime,
              renderMilliseconds: widget.controller.renderMilliseconds,
              style: context.theme.textTheme.headlineLarge,
            ),
          ),
        );
      },
    );
  }
}
