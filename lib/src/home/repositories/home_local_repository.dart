import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:interval/core/common/models/interval_session.dart';
import 'package:interval/core/errors/failure.dart';
import 'package:interval/core/utils/typedefs.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class HomeLocalRepository {
  const HomeLocalRepository(this._db);

  final Database _db;

  ResultFuture<List<IntervalSession>> getSessions({
    bool ascending = true,
  }) async {
    try {
      final intervalMaps = await _db.query(
        'intervals',
        orderBy: 'id ${ascending ? 'ASC' : 'DESC'}',
      );

      final intervals = intervalMaps.map(IntervalSession.fromMap).toList();
      return Right<Failure, List<IntervalSession>>(intervals);
    } on DatabaseException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      return const Left<Failure, List<IntervalSession>>(
        CacheFailure(
          message: 'Failed to get sessions from cache',
          statusCode: 'SESSIONS_UNK',
        ),
      );
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      return const Left<Failure, List<IntervalSession>>(
        CacheFailure(
          message: 'Failed to get sessions from cache',
          statusCode: 'SESSIONS_UNK',
        ),
      );
    }
  }

  ResultFuture<void> deleteIntervalSession(int id) async {
    try {
      await _db.delete(
        'intervals',
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(null);
    } on DatabaseException catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      return const Left<Failure, List<IntervalSession>>(
        CacheFailure(
          message: 'Failed to get sessions from cache',
          statusCode: 'SESSIONS_UNK',
        ),
      );
    } catch (e, s) {
      debugPrint('Error Occurred: $e');
      debugPrintStack(stackTrace: s);
      return const Left<Failure, List<IntervalSession>>(
        CacheFailure(
          message: 'Failed to get sessions from cache',
          statusCode: 'SESSIONS_UNK',
        ),
      );
    }
  }
}
