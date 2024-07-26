import 'package:interval/core/common/models/interval_session.dart';
import 'package:path/path.dart' as $path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  DatabaseHelper._internal();

  static final DatabaseHelper instance = DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbFactory = databaseFactoryFfi;
    final dbPath = $path.join(await getDatabasesPath(), 'intervals.db');
    return dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) {
          return db.execute(
            // ignore: missing_whitespace_between_adjacent_strings
            'CREATE TABLE intervals('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'mainTime INTEGER, '
            'workTime INTEGER, '
            'restTime INTEGER, '
            'createdAt STRING, '
            // ignore: missing_whitespace_between_adjacent_strings
            'lastUpdatedAt STRING'
            ')',
          );
        },
      ),
    );
  }

  Future<int> insertInterval(IntervalSession interval) async {
    final db = await database;
    return db.insert(
      'intervals',
      interval.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<IntervalSession>> getIntervals() async {
    final db = await database;
    final List<Map<String, dynamic>> intervalMaps = await db.query(
      'intervals',
      orderBy: 'id',
    );

    return intervalMaps.map(IntervalSession.fromMap).toList();
  }

  Future<IntervalSession?> getIntervalById(int id) async {
    final db = await database;

    final result = await db.query(
      'intervals',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return IntervalSession.fromMap(result.first);
  }

  Future<int> updateInterval(IntervalSession interval) async {
    final db = await database;
    return db.update(
      'intervals',
      interval.copyWith(lastUpdatedAt: DateTime.now()).toMap(),
      where: 'id = ?',
      whereArgs: [interval.id],
    );
  }

  Future<int> deleteInterval(int id) async {
    final db = await database;
    return db.delete(
      'intervals',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
