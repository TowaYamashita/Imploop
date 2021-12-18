import 'package:freezed_annotation/freezed_annotation.dart';
part 'task.freezed.dart';

@freezed
abstract class Task implements _$Task {
  const Task._();
  const factory Task({
    required int taskId,
    required String name,
    required int statusId,
  }) = _Task;

  factory Task.fromMap(Map task) {
    return Task(
      taskId: task['task_id'] as int,
      name: task['name'] as String,
      statusId: task['status_id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "task_id": taskId,
      "name": name,
      "status_id": statusId,
    };
  }
}
