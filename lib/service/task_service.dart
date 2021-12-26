import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/repository/task_repository.dart';
import 'package:imploop/repository/todo_repository.dart';
import 'package:imploop/service/task_type_service.dart';
import 'package:imploop/service/todo_type_service.dart';

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

  static Future<List<Todo>> getAllTodoInTask(int taskId) async {
    return await TodoRepository.getByTaskId(taskId) ?? [];
  }

  static Future<Todo?> registerNewTodo(
    Task task,
    String name,
    int estimate,
    TodoType? todoType,
  ) async {
    if (todoType == null) {
      return null;
    }

    late final TodoType registeredTodoType;
    if (todoType.todoTypeId == -1) {
      final tmp = await TodoTypeService.add(todoType.name);
      if (tmp == null) {
        return null;
      }
      registeredTodoType = tmp;
    } else {
      registeredTodoType = todoType;
    }

    return await TodoRepository.create(
      taskId: task.taskId,
      name: name,
      estimate: estimate,
      todoTypeId: registeredTodoType.todoTypeId,
    );
  }

  static Future<bool> editTask(int taskId, String name) async {
    return await TaskRepository.update(taskId, name);
  }

  static Future<bool> deleteTask(Task deletedTask) async {
    return await TaskRepository.delete(deletedTask);
  }
}
