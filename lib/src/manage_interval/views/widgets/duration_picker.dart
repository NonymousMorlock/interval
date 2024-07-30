import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:interval/core/extensions/context_extensions.dart';

class DurationPicker extends StatelessWidget {
  const DurationPicker({
    required this.title,
    this.initialDuration = Duration.zero,
    super.key,
    this.onPicked,
  });

  final String title;
  final Duration initialDuration;
  final ValueChanged<Duration>? onPicked;

  @override
  Widget build(BuildContext context) {
    debugPrint('Initial Duration: $initialDuration');
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.colorScheme.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        final duration = await showDurationPicker(
          context: context,
          initialDuration: initialDuration,
          showHead: false,
          durationPickerMode: DurationPickerMode.Minute,
          durationTypeChangerButtonColour:
              context.theme.colorScheme.primaryContainer,
          okTextColour: context.theme.colorScheme.secondary,
          cancelTextColour: context.theme.colorScheme.error,
          dialogStyle: DialogStyle(
            borderRadius: BorderRadius.circular(20),
          ),
        );
        debugPrint(duration?.inSeconds.toString());

        if (duration != null) {
          onPicked?.call(duration);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer, color: Colors.white),
          Text(title, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
