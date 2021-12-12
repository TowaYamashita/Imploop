import 'package:sample/domain/Task.dart';
import 'package:sample/repository/database_provider.dart';

/// Taskの永続化処理を行う
class TaskRepository{
  static String table = 'task';
  static DBProvider instance = DBProvider.instance;

  /// Taskを新規追加する
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

  /// 引数をtask_idに持つTaskを取得する
  static Future<Task?> get(int taskId) async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table WHERE task_id = ?', [taskId]);
    if (rows.isEmpty) return null;

    return Task.fromMap(rows.first);
  }
}