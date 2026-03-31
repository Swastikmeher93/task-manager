import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_manager/model/task_model.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();
  static Database? _database;

  void _log(String message) {
    print('[DatabaseService] $message');
  }

  Future<void> _printTasksTable(Database db) async {
    final rows = await db.query('tasks', orderBy: 'id ASC');

    _log('----- tasks table snapshot (${rows.length} row(s)) -----');
    if (rows.isEmpty) {
      _log('(empty)');
      _log('-----------------------------------------------');
      return;
    }

    for (final row in rows) {
      _log(row.toString());
    }
    _log('-----------------------------------------------');
  }

  Future<Database> get database async {
    if (_database != null) {
      _log('Using existing database instance.');
      return _database!;
    }

    _log('Opening database connection.');
    _database = await _initDatabase();
    _log('Database connection is ready.');
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'task_manager.db');
    _log('Initializing database at $path');

    return openDatabase(
      path,
      version: 3,
      onCreate: (db, version) async {
        _log('Creating tasks table for database version $version');
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            description TEXT NOT NULL,
            dueDate TEXT NOT NULL,
            status TEXT NOT NULL,
            blockedBy INTEGER NOT NULL DEFAULT 0,
            completedAt TEXT
          )
        ''');
        _log('Tasks table created successfully.');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        _log('Upgrading database from version $oldVersion to $newVersion');
        if (oldVersion < 2) {
          await db.execute(
            'ALTER TABLE tasks ADD COLUMN blockedBy INTEGER NOT NULL DEFAULT 0',
          );
          _log('Added blockedBy column to tasks table.');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE tasks ADD COLUMN completedAt TEXT');
          await db.execute("""
            UPDATE tasks
            SET completedAt = strftime('%Y-%m-%dT%H:%M:%fZ', 'now')
            WHERE status = 'completed' AND completedAt IS NULL
          """);
          _log('Added completedAt column and backfilled existing completed tasks.');
        }
      },
    );
  }

  Future<int> insertTask(TaskModel task) async {
    final db = await database;
    _log('Inserting task "${task.title}" with status ${task.status.name}');
    final taskId = await db.insert(
      'tasks',
      task.toMap(includeId: false),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    _log('Insert completed. New task id: $taskId');
    await _printTasksTable(db);
    return taskId;
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    _log('Fetching all tasks ordered by due date.');
    final maps = await db.query('tasks', orderBy: 'dueDate ASC');
    final tasks = maps.map(TaskModel.fromMap).toList();
    _log('Fetch completed. Retrieved ${tasks.length} task(s).');
    await _printTasksTable(db);
    return tasks;
  }

  Future<List<TaskModel>> searchTasks(String query) async {
    final db = await database;
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      _log('Search query is empty. Returning all tasks.');
      return getTasks();
    }

    _log('Searching tasks with query "$trimmedQuery"');
    final maps = await db.query(
      'tasks',
      where: 'title LIKE ? OR description LIKE ?',
      whereArgs: ['%$trimmedQuery%', '%$trimmedQuery%'],
      orderBy: 'dueDate ASC',
    );
    final tasks = maps.map(TaskModel.fromMap).toList();
    _log('Search completed. Found ${tasks.length} matching task(s).');
    return tasks;
  }

  Future<int> updateTask(TaskModel task) async {
    if (task.id == null) {
      throw ArgumentError('Task id is required for updates.');
    }

    final db = await database;
    _log(
      'Updating task id ${task.id} with title "${task.title}" and status ${task.status.name}',
    );
    final rowsAffected = await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
    _log('Update completed. Rows affected: $rowsAffected');
    await _printTasksTable(db);
    return rowsAffected;
  }

  Future<int> deleteTask(int id) async {
    final db = await database;
    _log('Deleting task id $id');
    final rowsAffected = await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
    _log('Delete completed. Rows affected: $rowsAffected');
    await _printTasksTable(db);
    return rowsAffected;
  }
}
