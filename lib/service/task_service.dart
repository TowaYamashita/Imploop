import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/repository/task_repository.dart';
import 'package:imploop/repository/todo_repository.dart';
import 'package:imploop/service/task_type_service.dart';

class TaskService {
  static Future<Task?> registerNewTask(String name, TaskType? taskType) async {
    if (taskType == null) {
      return null;
    }

    late final TaskType registeredTaskType;
    if (taskType.taskTypeId == -1) {
      final tmp = await TaskTypeService.add(taskType.name);
      if (tmp == null) {
        return null;
      }
      registeredTaskType = tmp;
    } else {
      registeredTaskType = taskType;
    }

    return await TaskRepository.create(name, registeredTaskType.taskTypeId);
  }

  static Future<List<Task>> getAllTask() async {
    return await TaskRepository.getAll() ?? [];
  }

  static Future<List<Task>> getAllTaskWithoutFinished() async {
    final List<Task> result = [];
    for (Task task in await TaskRepository.getAll() ?? []) {
      if (task.isFinished()) {
        result.add(task);
      }
    }
    return result;
  }

  static Future<List<Todo>> getAllTodoInTask(int taskId) async {
    return await TodoRepository.getByTaskId(taskId) ?? [];
  }

  /// 引数のtaskIdを持つ完了状態ではないTodoの一覧を取得する
  static Future<List<Todo>> getAllTodoWithoutFinishedInTask(int taskId) async {
    final List<Todo> result = [];
    for (Todo todo in await TodoRepository.getByTaskId(taskId) ?? []) {
      if (todo.isFinished()) {
        result.add(todo);
      }
    }
    return result;
  }

  static Future<bool> editTask(Task updatedTask) async {
    if (await TaskTypeService.existsTaskType(updatedTask.taskTypeId)) {
      return await TaskRepository.update(updatedTask);
    }
    return false;
  }

  static Future<bool> deleteTask(Task deletedTask) async {
    return await TaskRepository.delete(deletedTask);
  }

  /// 引数のTaskに完了状態ではないTodoがあるかどうか判定する
  /// 
  /// 完了状態ではないTodoが1つでもあればtrue、そうでなければfalseを返す
  static Future<bool> containsNonFinishedTodo(Task task) async {
    return (await getAllTodoWithoutFinishedInTask(task.taskId)).isEmpty;
  }
}
