import 'package:note_book_app/models/note.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class DB {
  late Database _database;
  final String table = "notes";

  Future<Database> get db async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    var dir = await getDatabasesPath();
    String path = p.join(dir, "noteup.db");
    // there might be an error with the p.join
    var database = await openDatabase(path, version: 1,
        onCreate: (Database _db, int version) async {
      await _db.execute(
          "CREATE TABLE $table(id INTEGER PRIMARY KEY AUTOINCREMENT, date INTEGER, title TEXT, content TEXT)");
    });
    return database;
  }

  Future<void> add(Note note) async {
    var database = await db;
    note.setDate();
    await database.insert(table, note.toMap());
  }

  Future<void> update(Note note) async {
    var database = await db;
    note.setDate();
    await database
        .update(table, note.toMap(), where: "id = ?", whereArgs: [note.id]);
  }

  Future<void> delete(Note note) async {
    var database = await db;
    await database.delete(table, where: "id=?", whereArgs: [note.id]);
  }

  Future<List<Note>> getNotes() async {
    var database = await db;
    List<Map<String, dynamic>> maps =
        await database.rawQuery("SELET * FROM $table ORDER BY date DESC");
    List<Note> notes = <Note>[];
    // there might be error with the <note>
    for (Map<String, dynamic> map in maps) {
      notes.add(Note.fromMap(map));
    }
    return notes;
  }
}
