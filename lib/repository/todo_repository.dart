import 'package:sample/domain/todo.dart';
import 'package:sample/repository/database_provider.dart';

class TodoRepository {
  static String table = 'todo';
  static DBProvider instance = DBProvider.instance;

  static Future<Todo> create({
    required int taskId,
    required String name,
    required int estimate,
    int? elapsed,
  }) async {
    final Map<String, dynamic> row = {
      "taskId": taskId,
      "name": name,
      "estimate": estimate,
      "elapsed": elapsed,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return Todo(
      todoId: id,
      taskId: row["taskId"] as int,
      name: row["name"] as String,
      statusId: 1,
      estimate: row["estimate"] as int,
      elapsed: row["elapsed"] as int?,
    );
  }

  static Future<Todo?> get(int todoId) async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table WHERE id = ?', [todoId]);
    if (rows.isEmpty) return null;

    return Todo.fromMap(rows.first);
  }
}
