import 'package:imploop/domain/todo.dart';
import 'package:imploop/repository/database_provider.dart';

/// Todoの永続化処理を行う
class TodoRepository {
  static String table = 'todo';
  static DBProvider instance = DBProvider.instance;

  /// Todoを新規追加する
  static Future<Todo> create({
    required int taskId,
    required String name,
    required int estimate,
    int? elapsed,
  }) async {
    final Map<String, dynamic> row = {
      "task_id": taskId,
      "name": name,
      "estimate": estimate,
      "elapsed": elapsed,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return Todo(
      todoId: id,
      taskId: row["task_id"] as int,
      name: row["name"] as String,
      statusId: 1,
      estimate: row["estimate"] as int,
      elapsed: row["elapsed"] as int?,
    );
  }

  /// 引数をtodo_idに持つtodoを取得する
  static Future<Todo?> get(int todoId) async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table WHERE todo_id = ?', [todoId]);
    if (rows.isEmpty) return null;

    return Todo.fromMap(rows.first);
  }

  /// 引数をtask_idに持つtodoを取得する
  static Future<List<Todo>?> getByTaskId(int taskId) async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table WHERE task_id = ?', [taskId]);
    if (rows.isEmpty) return null;

    final List<Todo> todosInTask = [];
    for (var element in rows) {
      final Todo todoInTask = Todo.fromMap(element);
      todosInTask.add(todoInTask);
    }
    return todosInTask;
  }
}
