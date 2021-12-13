import 'package:sample/domain/task.dart';
import 'package:sample/repository/task_repository.dart';

class TaskService {
  static Future<Task> registerNewTask(String name) async{
    return await TaskRepository.create(name);
  }

  static Future<List<Task>> getAllTask() async{
    return await TaskRepository.getAll() ?? [];
  }
}
