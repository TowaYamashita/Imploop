import 'package:imploop/domain/tag.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_notice.dart';
import 'package:imploop/repository/todo_notice_repository.dart';
import 'package:imploop/service/tag_service.dart';
import 'package:imploop/service/todo_service.dart';

class TodoNoticeService {
  /// Todoの振り返りを記録する
  ///
  /// 記録に成功すればtrue、そうでなければfalseを返す
  Future<bool> register(Todo todo, Tag tag, String body) async {
    // DB上に存在しないTodoは記録できない
    if (!await TodoService.existsTodo(todo)) {
      return false;
    }
    // DB上に存在しないTagは記録できない
    if (!await TagService.existsTag(tag)) {
      return false;
    }

    return await TodoNoticeRepository.create(
          todo.todoId,
          tag.tagId,
          body,
        ) !=
        null;
  }

  /// Todoに紐づく振り返りをすべて取得する
  /// 
  /// 1件も無ければnullを返す
  Future<List<TodoNotice>?> getTodoNoticeList(Todo todo) async{
    return await TodoNoticeRepository.getByTodoId(todo.todoId);
  }
}
