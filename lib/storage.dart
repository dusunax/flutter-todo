import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:todo/todo.dart';

class TodoStorage {
  TodoStorage({required this.databasePath});
  final String databasePath;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Database? _database;

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = '$dbPath/$databasePath';
    final database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
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

  Future<TodoDBType> create(TodoDBType todo) async {
    final db = await database;

    final id = await db.insert(TodoDBType.tableTodos, todo.toMap());
    return todo.copy(id: id);
  }

  Future<TodoDBType?> read(int id) async {
    final db = await database;

    final maps = await db.query(
      TodoDBType.tableTodos,
      columns: TodoDBType.values,
      where: '${TodoDBType.columnId} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TodoDBType.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List<TodoDBType>> readAll() async {
    final db = await database;

    const orderBy =
        '${TodoDBType.columnIsChecked}, ${TodoDBType.columnId} DESC';
    final result = await db.query(TodoDBType.tableTodos, orderBy: orderBy);

    return result.map((json) => TodoDBType.fromMap(json)).toList();
  }

  Future<int> update(TodoDBType todo) async {
    final db = await database;

    return db.update(
      TodoDBType.tableTodos,
      todo.toMap(),
      where: '${TodoDBType.columnId} = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      TodoDBType.tableTodos,
      where: '${TodoDBType.columnId} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await database;

    db.close();
  }
}
