import 'package:sample/domain/Task.dart';
import 'package:sample/repository/database_provider.dart';

class TaskRepository{
  static String table = 'task';
  static DBProvider instance = DBProvider.instance;

  static Future<Task> create(String name) async {
    final Map<String, String> row = {
      "name": name,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return Task(
      taskId: id, 
      name: name,
      statusId: 1,
    );
  }

  static Future<Task?> get(int id) async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table WHERE id = ?', [id]);
    if (rows.isEmpty) return null;

    return Task.fromMap(rows.first);
  }
}