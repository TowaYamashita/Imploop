import 'package:imploop/domain/task.dart';
import 'package:imploop/repository/database_provider.dart';

/// Taskの永続化処理を行う
class TaskRepository {
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
    final rows =
        await db.rawQuery('SELECT * FROM $table WHERE task_id = ?', [taskId]);
    if (rows.isEmpty) return null;

    return Task.fromMap(rows.first);
  }

  /// DBに保存されているTaskをすべて取得する
  static Future<List<Task>?> getAll() async {
    final db = await instance.database;
    final rows = await db.rawQuery('SELECT * FROM $table');
    if (rows.isEmpty) return null;

    final List<Task> allTask = [];
    for (var element in rows) {
      final Task task = Task.fromMap(element);
      allTask.add(task);
    }
    return allTask;
  }

  /// Taskの名前を更新する
  ///
  /// 更新に成功したらtrue、そうでなかればfalseが返ってくる
  static Future<bool> update(int taskId, String name) async {
    final db = await instance.database;
    final int affectedRowCount = await db.update(table, {"name": name},
        where: "task_id=?", whereArgs: [taskId]);

    return affectedRowCount > 0 ? true : false;
  }
}
