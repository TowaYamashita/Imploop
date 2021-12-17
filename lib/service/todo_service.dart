import 'package:imploop/domain/todo.dart';
import 'package:imploop/repository/todo_repository.dart';

class TodoService {
  static Future<bool> editTask(Todo updatedTodo) async {
    return await TodoRepository.update(updatedTodo);
  }
}
