import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/models/repetition.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _tasksTableName = 'tasks';
  final String _tasksIdColumnName = 'id';
  final String _tasksContentColumnName = 'content';
  final String _tasksStatusColumnName = 'status';
  final String _tasksInitialDateColumnName = 'initialDate';
  final String _tasksInitialTimeColumnName = 'initialTime';
  final String _tasksDurationColumnName = 'duration';
  final String _tasksRepetitionIdColumnName = 'repetitionId';

  final String _repetitionTableName = 'repetition';
  final String _repetitionIdColumnName = 'id';
  final String _repetitionNameColumnName = 'name';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'database.db');
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_repetitionTableName (
          $_repetitionIdColumnName INTEGER PRIMARY KEY,
          $_repetitionNameColumnName TEXT UNIQUE NOT NULL
        )
        ''');

        db.execute('''
        CREATE TABLE $_tasksTableName (
          $_tasksIdColumnName INTEGER PRIMARY KEY,
          $_tasksContentColumnName TEXT NOT NULL,
          $_tasksStatusColumnName INTEGER NOT NULL,
          $_tasksInitialDateColumnName TEXT NOT NULL,
          $_tasksInitialTimeColumnName TEXT NOT NULL,
          $_tasksDurationColumnName TEXT NOT NULL,
          $_tasksRepetitionIdColumnName INT NOT NULL,
          FOREIGN KEY($_tasksRepetitionIdColumnName) REFERENCES $_repetitionTableName($_repetitionIdColumnName) ON DELETE CASCADE
        )
        ''');
      },
    );
    initRepetitionTable();
    return database;
  }

  void initRepetitionTable() async {
    final db = await database;
    for (var repetition in Repetition.listRepetitions) {
      await db.insert(
        _repetitionTableName,
        {
          _repetitionNameColumnName: repetition,
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  Future<List<Repetition>> getRepetitions() async {
    final db = await database;
    final data = await db.query(_repetitionTableName);
    return data
        .map(
          (e) => Repetition(
            id: e['id'] as int,
            name: e['name'] as String,
          ),
        )
        .toList();
  }

  Future<Repetition> getRepetitionById(int id) async {
    final db = await database;
    final data = await db.query(
      _repetitionTableName,
      where: "id = ?",
      whereArgs: [id],
    );
    return data
        .map(
          (e) => Repetition(
            id: e['id'] as int,
            name: e['name'] as String,
          ),
        )
        .toList()[0];
  }

  void addTask(String content, String initialDate, int repetitionId) async {
    final db = await database;
    await db.insert(
      _tasksTableName,
      {
        _tasksContentColumnName: content,
        _tasksStatusColumnName: 0,
        _tasksInitialDateColumnName: initialDate,
        _tasksInitialTimeColumnName: "",
        _tasksDurationColumnName: "",
        _tasksRepetitionIdColumnName: repetitionId,
      },
    );
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final data = await db.rawQuery('''
    SELECT
      t.id,
      t.content,
      t.status,
      t.initialDate,
      t.initialTime,
      t.duration,
      r.id AS repetitionId,
      r.name AS repetitionName
    FROM $_tasksTableName AS t
    INNER JOIN $_repetitionTableName AS r ON t.repetitionId = r.id
    ''', []);
    return data
        .map(
          (e) => Task(
            id: e['id'] as int,
            content: e['content'] as String,
            status: e['status'] as int,
            initialDate: e['initialDate'] as String,
            duration: e['duration'] as String,
            initialTime: e['initialTime'] as String,
            repetition: Repetition(
              id: e['repetitionId'] as int,
              name: e['repetitionText'] as String,
            ),
          ),
        )
        .toList();
  }

  Future<List<Task>> getTasksByDate(String date) async {
    final db = await database;
    final data = await db.rawQuery('''
    SELECT
      t.id,
      t.content,
      t.status,
      t.initialDate,
      t.initialTime,
      t.duration,
      r.id AS repetitionId,
      r.name AS repetitionName
    FROM $_tasksTableName AS t
    INNER JOIN $_repetitionTableName AS r ON t.repetitionId = r.id
    WHERE t.initialDate = ?
    ''', [date]);
    return data
        .map(
          (e) => Task(
            id: e['id'] as int,
            content: e['content'] as String,
            status: e['status'] as int,
            initialDate: e['initialDate'] as String,
            duration: e['duration'] as String,
            initialTime: e['initialTime'] as String,
            repetition: Repetition(
              id: e['repetitionId'] as int,
              name: e['repetitionName'] as String,
            ),
          ),
        )
        .toList();
  }

  void updateTaskStatus(int id, int status) async {
    final db = await database;
    db.update(
        _tasksTableName,
        {
          _tasksStatusColumnName: status,
        },
        where: 'id = ?',
        whereArgs: [id]);
  }

  void deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: 'id =?',
      whereArgs: [id],
    );
  }
}
