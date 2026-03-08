import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/paper.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() => _instance;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'edupulse.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT UNIQUE,
        authors TEXT,
        summary TEXT,
        pdfUrl TEXT,
        publishedYear TEXT,
        primaryCategory TEXT
      )
    ''');
  }

  Future<int> insertPaper(Paper paper) async {
    final db = await database;
    return await db.insert(
      'favorites',
      paper.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deletePaper(String title) async {
    final db = await database;
    return await db.delete('favorites', where: 'title = ?', whereArgs: [title]);
  }

  Future<List<Paper>> getFavoritePapers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('favorites');

    return List.generate(maps.length, (i) {
      return Paper.fromMap(maps[i]);
    });
  }

  Future<bool> isFavorite(String title) async {
    final db = await database;
    final maps = await db.query(
      'favorites',
      where: 'title = ?',
      whereArgs: [title],
    );
    return maps.isNotEmpty;
  }
}
