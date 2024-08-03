import 'package:path/path.dart' as $path;
import 'package:sqflite/sqflite.dart' as mobile;
import 'package:sqflite_common_ffi/sqflite_ffi.dart' as desktop;

sealed class DatabaseHelper {
  static const createIntervalsTableQuery =
      // ignore: missing_whitespace_between_adjacent_strings
      'CREATE TABLE intervals('
      'id INTEGER PRIMARY KEY AUTOINCREMENT, '
      'title STRING UNIQUE NOT NULL, '
      'mainTime INTEGER NOT NULL, '
      'workTime INTEGER NOT NULL, '
      'restTime INTEGER NOT NULL, '
      'createdAt STRING NOT NULL, '
      'description STRING, '
      'prioritizeOverlap INTEGER NOT NULL, '
      // ignore: missing_whitespace_between_adjacent_strings
      'lastUpdatedAt STRING'
      ')';

  static Future<desktop.Database> initDatabaseDesktop() async {
    desktop.databaseFactory = desktop.databaseFactoryFfi;
    final dbPath = $path.join(await desktop.getDatabasesPath(), 'intervals.db');
    return desktop.databaseFactory.openDatabase(
      dbPath,
      options: desktop.OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) {
          return db.execute(createIntervalsTableQuery);
        },
      ),
    );
  }

  static Future<mobile.Database> initDatabaseMobile() async {
    final dbPath = $path.join(await mobile.getDatabasesPath(), 'intervals.db');

    return mobile.openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        return db.execute(createIntervalsTableQuery);
      },
    );
  }

// Future<IntervalSession?> getIntervalById(int id) async {
//   final db = await database;
//
//   final result = await db.query(
//     'intervals',
//     where: 'id = ?',
//     whereArgs: [id],
//     limit: 1,
//   );
//
//   if (result.isEmpty) return null;
//
//   return IntervalSession.fromMap(result.first);
// }
}
