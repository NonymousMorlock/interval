import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/errors/failure.dart';
import 'package:interval/core/utils/typedefs.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class ManageIntervalLocalRepository {
  const ManageIntervalLocalRepository(this._db);

  final Database _db;

  ResultFuture<int> saveIntervalSession(IntervalSession interval) async {
    try {
      final result = await _db.insert(
        'intervals',
        interval.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return Right(result);
    } on DatabaseException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      return const Left(
        CacheFailure(
          message: 'Failed to get sessions from cache',
          statusCode: 'SAVE_SESSION_UNK',
        ),
      );
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      return const Left(
        CacheFailure(
          message: 'Failed to get sessions from cache',
          statusCode: 'SAVE_SESSION_UNK',
        ),
      );
    }
  }

  ResultFuture<int> updateIntervalSession(IntervalSession interval) async {
    try {
      final result = await _db.update(
        'intervals',
        interval.copyWith(lastUpdatedAt: DateTime.now()).toMap(),
        where: 'id = ?',
        whereArgs: [interval.id],
      );
      return Right(result);
    } on DatabaseException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      return const Left(
        CacheFailure(
          message: 'Failed to get sessions from cache',
          statusCode: 'UPDATE_SESSION_UNK',
        ),
      );
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      return const Left(
        CacheFailure(
          message: 'Failed to get sessions from cache',
          statusCode: 'UPDATE_SESSION_UNK',
        ),
      );
    }
  }
}
