import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/utils/typedefs.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {
  final intervalSession = IntervalSession.empty().copyWith(
    createdAt: DateTime.parse('2024-07-27T22:55:26.457'),
  );

  final tMap = jsonDecode(fixture('interval_session.json')) as DataMap;

  group('toMap', () {
    test(
      'should return a [Map] with the appropriate key and value pairs '
      'EXCLUDING [id]',
      () {
        final tMapCopy = Map<String, dynamic>.from(tMap)..remove('id');

        final result = intervalSession.toMap();
        expect(result, tMapCopy);
      },
    );
  });

  group('fromMap', () {
    test(
      'should return a valid [IntervalSession] instance from a [Map]',
      () {
        final result = IntervalSession.fromMap(tMap);
        expect(result, intervalSession);
      },
    );
  });

  group('copyWith', () {
    test(
      'should return a new [IntervalSession] instance with the updated values',
      () {
        final newIntervalSession = intervalSession.copyWith(
          title: 'New Title',
          prioritizeOverlap: true,
          mainTime: 10,
          workTime: 10,
          restTime: 10,
          description: 'New Description',
          lastUpdatedAt: DateTime.parse('2024-07-27T22:55:26.457'),
        );

        expect(intervalSession, isNot(newIntervalSession));
      },
    );
  });
}
