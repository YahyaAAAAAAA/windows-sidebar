import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:windows_widgets/models/side_file.dart';
import 'package:windows_widgets/models/side_folder.dart';
import 'package:windows_widgets/models/side_item.dart';
import 'dart:math';

class DatabaseHelper {
  static Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'side_items.db'),
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE side_items (
            id INTEGER PRIMARY KEY,
            type TEXT,
            path TEXT,
            name TEXT,
            icon BLOB
          )
        ''');
      },
      version: 1,
    );
  }

  static int generateUniqueId() {
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    final int randomValue = Random().nextInt(1000);
    return timestamp + randomValue;
  }

  static Future<void> insertSideItem(SideItem item) async {
    final db = await DatabaseHelper.initDatabase();
    final int id = generateUniqueId();
    await db.insert('side_items', item.toMap()..['id'] = id);
  }

  static Future<List<SideItem>> getSideItems() async {
    final db = await DatabaseHelper.initDatabase();
    final List<Map<String, dynamic>> maps = await db.query('side_items');

    return List.generate(maps.length, (i) {
      if (maps[i]['type'] == 'file') {
        return SideFile(
          id: maps[i]['id'],
          path: maps[i]['path'],
          name: maps[i]['name'],
          icon: maps[i]['icon'], // Convert BLOB back to Uint8List
        );
      } else {
        return SideFolder(
          id: maps[i]['id'],
          path: maps[i]['path'],
          name: maps[i]['name'],
        );
      }
    });
  }

  static Future<void> deleteSideItem(int id) async {
    final db = await DatabaseHelper.initDatabase();
    await db.delete('side_items', where: 'id = ?', whereArgs: [id]);
  }
}
