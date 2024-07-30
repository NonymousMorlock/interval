extension DurationExtensions on Duration {
  int get hoursPart => inHours.remainder(Duration.hoursPerDay);

  int get minutesPart => inMinutes % Duration.minutesPerHour;

  int get secondsPart => inSeconds % Duration.secondsPerMinute;

  int get millisecondsPart => inMilliseconds % Duration.millisecondsPerSecond;

  int get microsecondsPart =>
      inMicroseconds % Duration.microsecondsPerMillisecond;

  String get timeInWords {
    String twoDigits(int n) => n.toString().padLeft(2, '0');

    if (inDays > 0) {
      final hours = twoDigits(hoursPart);
      final minutes = twoDigits(minutesPart);
      final seconds = twoDigits(secondsPart);
      return '$inDays day(s) '
              '${hoursPart > 0 ? '$hours hour(s) ' : ''}'
              '${minutesPart > 0 ? '$minutes minute(s) ' : ''}'
              '${secondsPart > 0 ? '$seconds second(s)' : ''}'
          .trim();
    } else if (inHours > 0) {
      final minutes = twoDigits(minutesPart);
      final seconds = twoDigits(secondsPart);
      return '$inHours hour(s) '
              '${minutesPart > 0 ? '$minutes minute(s) ' : ''}'
              '${secondsPart > 0 ? '$seconds second(s)' : ''}'
          .trim();
    } else if (inMinutes > 0) {
      final seconds = twoDigits(secondsPart);
      return '$inMinutes minute(s) '
              '${secondsPart > 0 ? '$seconds second(s)' : ''}'
          .trim();
    } else if (inSeconds > 0) {
      final milliseconds = twoDigits(millisecondsPart);
      return '$inSeconds second(s) '
              '${millisecondsPart > 0 ? '$milliseconds millisecond(s) ' : ''}'
          .trim();
    } else if (inMilliseconds > 0) {
      final microseconds = twoDigits(microsecondsPart);
      return '$inMilliseconds millisecond(s) '
              '${microsecondsPart > 0 ? '$microseconds microsecond(s)' : ''}'
          .trim();
    } else {
      return '$inMicroseconds microsecond(s)'.trim();
    }
  }
}
