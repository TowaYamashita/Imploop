import 'package:imploop/domain/todo.dart';
import 'package:imploop/repository/todo_repository.dart';
import 'package:imploop/util/time_util.dart';

class TodoService {
  static Future<bool> editTodo(Todo updatedTodo) async {
    return await TodoRepository.update(updatedTodo);
  }

  static Future<bool> deleteTodo(Todo updatedTodo) async {
    return await TodoRepository.delete(updatedTodo);
  }

  static Future<bool> finishTodo(Todo finishedTodo, int elapsed) async {
    return await TodoRepository.update(
      finishedTodo.copyWith(
        elapsed: toMinutes(elapsed),
        statusId: 3,
      ),
    );
  }
}
