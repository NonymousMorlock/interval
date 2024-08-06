import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class Controls extends StatefulWidget {
  const Controls({
    super.key,
    this.onPause,
    this.onPlay,
    this.onStop,
    this.onResume,
  });

  final VoidCallback? onPause;
  final VoidCallback? onPlay;
  final VoidCallback? onResume;
  final VoidCallback? onStop;

  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> {
  bool showPlay = true;
  bool showPause = false;
  bool showStop = false;

  bool canResume = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton.filled(
          style: IconButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
          ),
          isSelected: showPause,
          icon: const Icon(Icons.play_arrow),
          iconSize: 40,
          selectedIcon: const Icon(Icons.pause),
          onPressed: () {
            if (showPlay) {
              if (canResume) {
                setState(() {
                  showPlay = false;
                  showPause = true;
                });
                canResume = false;
                widget.onResume?.call();
                return;
              }
              setState(() {
                showPlay = false;
                showPause = true;
                showStop = true;
              });
              widget.onPlay?.call();
            } else {
              setState(() {
                showPlay = true;
                showPause = false;
              });
              canResume = true;
              widget.onPause?.call();
            }
          },
        ),
        if (showStop) ...[
          const Gap(10),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            icon: const Icon(Icons.stop),
            onPressed: () {
              setState(() {
                showPlay = true;
                showPause = false;
                showStop = false;
              });
              widget.onStop?.call();
            },
          ),
        ],
      ],
    );
  }
}
