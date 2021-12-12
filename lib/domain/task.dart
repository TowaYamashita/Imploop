class Task {
  final int taskId;
  final String name;
  final int statusId;

  Task({
    required this.taskId,
    required this.name,
    required this.statusId,
  });

  factory Task.fromMap(Map task) {
    return Task(
      taskId: task['taskId'] as int,
      name: task['name'] as String,
      statusId: task['status_id'] as int,
    );
  }
}
