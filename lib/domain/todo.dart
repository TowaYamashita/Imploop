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
      todoId: todo["todoId"] as int,
      taskId: todo["taskId"] as int,
      name: todo["name"] as String,
      statusId: todo["statusId"] as int,
      estimate: todo["estimate"] as int,
      elapsed: todo["elapsed"] as int?,
    );
  }
}
