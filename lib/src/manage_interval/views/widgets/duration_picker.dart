import 'package:duration_picker_dialog_box/duration_picker_dialog_box.dart';
import 'package:flutter/material.dart';
import 'package:interval/core/extensions/context_extensions.dart';
import 'package:interval/core/extensions/duration_extensions.dart';

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
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: context.theme.colorScheme.primary,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        var durationPickerMode = DurationPickerMode.Minute;
        if (initialDuration.inDays > 0) {
          durationPickerMode = DurationPickerMode.Day;
        } else if (initialDuration.hoursPart > 0) {
          durationPickerMode = DurationPickerMode.Hour;
        } else if (initialDuration.minutesPart > 0) {
          durationPickerMode = DurationPickerMode.Minute;
        } else if (initialDuration.secondsPart > 0) {
          durationPickerMode = DurationPickerMode.Second;
        } else if (initialDuration.millisecondsPart > 0) {
          durationPickerMode = DurationPickerMode.MilliSecond;
        } else if (initialDuration.microsecondsPart > 0) {
          durationPickerMode = DurationPickerMode.MicroSecond;
        }
        final duration = await showDurationPicker(
          context: context,
          initialDuration: initialDuration,
          showHead: false,
          durationPickerMode: durationPickerMode,
          durationTypeChangerButtonColour:
              context.theme.colorScheme.primaryContainer,
          okTextColour: context.theme.colorScheme.secondary,
          cancelTextColour: context.theme.colorScheme.error,
          dialogStyle: DialogStyle(
            borderRadius: BorderRadius.circular(20),
          ),
        );
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
