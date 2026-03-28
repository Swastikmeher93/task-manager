import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/model/task_model.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'task_manager.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            dueDate TEXT NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    return db.insert(
      'tasks',
      task.toMap(includeId: false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final maps = await db.query('tasks', orderBy: 'dueDate ASC');
    return maps.map(TaskModel.fromMap).toList();
  }

  Future<int> updateTask(TaskModel task) async {
    if (task.id == null) {
      throw ArgumentError('Task id is required for updates.');
    }

    final db = await database;
    return db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    return db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
