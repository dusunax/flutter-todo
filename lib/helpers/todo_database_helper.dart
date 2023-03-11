import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:todo/todo.dart';

class TodoDatabaseHelper {
  TodoDatabaseHelper._privateConstructor();
  static final TodoDatabaseHelper instance =
      TodoDatabaseHelper._privateConstructor();

  static const String _databaseName = 'todo.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  Future<Database> init({required String databasePath}) async {
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
    CREATE TABLE todos (
      id INTEGER PRIMARY KEY,
      title TEXT,
      isChecked INTEGER
    )
''');
  }

  Future<int> create(TodoDBType todo) async {
    final db = _database;
    if (db == null) return 0;
    return await db.insert('todos', todo.toMap());
  }

  Future<TodoDBType> saveTodo(int id, TodoDBType todo) async {
    final db = _database;
    db?.insert(
      // 새 레코드 추가
      tableTodo,
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // 새 정보로 만든 newTodo
    final newTodo = TodoDBType(
      id: id,
      title: todo.title,
      isChecked: todo.isChecked,
    );

    return newTodo;
  }

  Future<List<TodoDBType>> readAll() async {
    final db = _database;
    if (db == null) return [];
    final List<Map<String, dynamic>> maps = await db.query('todos');
    return List.generate(maps.length, (i) {
      return TodoDBType.fromMap(maps[i]);
    });
  }

  Future<int> update(TodoDBType todo) async {
    final db = _database;
    if (db == null) return 0;
    return await db
        .update('todos', todo.toMap(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> delete(TodoDBType todo) async {
    final db = _database;
    if (db == null) return 0;
    return await db.delete('todos', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<List<TodoDBType>> getAllTodos() async {
    final db = await TodoDatabaseHelper.instance
        .init(databasePath: 'path/to/database');
    final result = await db.query('todos');
    return result.map((e) => TodoDBType.fromMap(e)).toList();
  }
}
