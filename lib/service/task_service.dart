import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/repository/task_repository.dart';
import 'package:imploop/repository/todo_repository.dart';

class TaskService {
  static Future<Task> registerNewTask(String name) async {
    return await TaskRepository.create(name);
  }

  static Future<List<Task>> getAllTask() async {
    return await TaskRepository.getAll() ?? [];
  }

  static Future<List<Todo>> getAllTodoInTask(int taskId) async {
    return await TodoRepository.getByTaskId(taskId) ?? [];
  }

  static Future<Todo> registerNewTodo(
    int taskId,
    String name,
    int estimate,
  ) async {
    return await TodoRepository.create(
      taskId: taskId,
      name: name,
      estimate: estimate,
    );
  }
}
