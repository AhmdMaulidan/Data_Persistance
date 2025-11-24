import 'package:path/path.dart';
import 'package:shared_preference/models/note_model.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> initDB() async {
    if (_db != null) return _db!;
    final path = join(await getDatabasesPath(), 'notes.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE notes(
id INTEGER PRIMARY KEY AUTOINCREMENT,
title TEXT,
content TEXT
)
''');
      },
    );
    return _db!;
  }

  static Future<List<NoteModel>> getNotes() async {
    final db = await initDB();
    final rows = await db.query('notes', orderBy: 'id DESC');
    return rows.map((r) => NoteModel.fromMap(r)).toList();
  }

  static Future<int> addNote(NoteModel note) async {
    final db = await initDB();
    return await db.insert('notes', note.toMap());
  }

  static Future<int> updateNote(NoteModel note) async {
    final db = await initDB();
    return await db.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  static Future<int> deleteNote(int id) async {
    final db = await initDB();
    return await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }
}