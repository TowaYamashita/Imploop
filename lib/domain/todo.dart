import 'package:freezed_annotation/freezed_annotation.dart';
part 'todo.freezed.dart';

@freezed
abstract class Todo implements _$Todo {
  const Todo._();
  const factory Todo({
    required int todoId,
    required int taskId,
    required String name,
    required int statusId,
    required int estimate,
    int? elapsed,
  }) = _Todo;

  factory Todo.fromMap(Map todo) {
    return Todo(
      todoId: todo["todo_id"] as int,
      taskId: todo["task_id"] as int,
      name: todo["name"] as String,
      statusId: todo["status_id"] as int,
      estimate: todo["estimate"] as int,
      elapsed: todo["elapsed"] as int?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "todo_id": todoId,
      "task_id": taskId,
      "name": name,
      "status_id": statusId,
      "estimate": estimate,
      "elapsed": elapsed,
    };
  }
}
