import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DBHelper {
  static const String table = "bookmarks";
  static const String url = "url";
  static const String title = "title";
  static const String imgurl = "imgurl";
  static const String src = "src";
  static const String pub = "pub";
  static const String desc = "desc";

  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'bookmarks.db'),
        onCreate: (db, ver) {
      return db.execute(
          'create table bookmarks($url text primary key, $desc text, $title text, $imgurl text, $src text, $pub text)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    await db.insert(table, data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<void> delID(String id) async {
    final db = await DBHelper.database();
    await db.execute("delete from bookmarks where url=\"$id\"");
  }
}
