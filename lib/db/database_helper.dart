import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/memo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper.init();

  static Database? _database;

  DatabaseHelper.init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('memo.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = ' INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textTypeNull = 'TEXT';
    const boolType = 'BOOLEAN NOT NULL';
    await db.execute('''
CREATE TABLE $tableMemo (
      ${MemoFields.id} $idType,
      ${MemoFields.isDone} $boolType,
      ${MemoFields.type} $textType,
      ${MemoFields.title} $textType,
      ${MemoFields.description} $textTypeNull,
      ${MemoFields.time} $textType,
      ${MemoFields.lastUpdated} $textTypeNull
    )
    ''');
  }

  Future<Memo> create(Memo memo) async {
    final db = await instance.database;
    final id = await db.insert(tableMemo, memo.toJson());
    return memo.copy(id: id);
  }

  Future<Memo> readeMemo(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableMemo,
      columns: MemoFields.values,
      where: '${MemoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isEmpty) {
      return Memo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Memo>> fetchMemos() async {
    final db = await instance.database;
    const orderby = '${MemoFields.time} DESC';
    final result = await db.query(
      tableMemo,
      columns: MemoFields.values,
      orderBy: orderby,
    );
    return result.map((json) => Memo.fromJson(json)).toList();
  }

  Future<int> updateMemo(Memo memo) async {
    final db = await instance.database;
    return db.update(
      tableMemo,
      memo.toJson(),
      where: '${MemoFields.id}=?',
      whereArgs: [memo.id],
    );
  }

  Future<int> deleteMemo(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMemo,
      where: '${MemoFields.id}=?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAllMemo() async {
    final db = await instance.database;
    await db.delete(
      tableMemo,
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
