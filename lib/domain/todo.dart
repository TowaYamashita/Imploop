class Todo {
  final int todoId;
  final int taskId;
  final String name;
  final int statusId;
  final int estimate;
  final int? elapsed;

  Todo({
    required this.todoId,
    required this.taskId,
    required this.name,
    required this.statusId,
    required this.estimate,
    this.elapsed,
  });

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
      "todoId": todoId,
      "taskId": taskId,
      "name": name,
      "statusId": statusId,
      "estimate": estimate,
      "elapsed:": elapsed,
    };
  }
}
