import 'dart:convert';

import 'package:interval/core/enums/overlap.dart';
import 'package:interval/core/utils/typedefs.dart';

({Overlap overlap, Duration overlapDuration}) checkOverlap(String json) {
  final dataMap = jsonDecode(json) as DataMap;
  final mainTime = Duration(microseconds: (dataMap['mainTime'] as num).toInt());
  final workTime = Duration(microseconds: (dataMap['workTime'] as num).toInt());
  final restTime = Duration(microseconds: (dataMap['restTime'] as num).toInt());

  if (mainTime == Duration.zero ||
      workTime == Duration.zero ||
      restTime == Duration.zero) {
    return (overlap: Overlap.NONE, overlapDuration: Duration.zero);
  }

  var totalTime = mainTime;
  var overlap = Overlap.NONE;
  var overlapDuration = Duration.zero;

  while (totalTime > Duration.zero) {
    if (totalTime < workTime) {
      overlap = Overlap.WORK;
      overlapDuration = workTime - totalTime;
      break;
    }
    totalTime -= workTime;
    if (totalTime < restTime) {
      overlap = Overlap.REST;
      overlapDuration = restTime - totalTime;
      break;
    }
    totalTime -= restTime;
  }

  return (overlap: overlap, overlapDuration: overlapDuration);
}
