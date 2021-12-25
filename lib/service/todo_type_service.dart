import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/repository/todo_type_repository.dart';

class TodoTypeService {
  /// 新しく登録しようとしているTypeがすでに登録されていないか判定する
  ///
  /// すでに登録されていればtrue、そうでなければfalseを返す
  static Future<bool> hasAlreadyRegistered(String name) async {
    final List<TodoType> registeredTodoTypeList = await TodoTypeRepository.getAll() ?? [];
    return registeredTodoTypeList
        .where((registeredTodoType) => registeredTodoType.name == name)
        .isNotEmpty;
  }

  /// 新しいTodoTypeを登録する
  ///
  /// 登録することができれば新しく登録したTodoTypeのデータを持つTodoTypeクラスを
  ///
  /// 登録できなければ、nullを返す
  static Future<TodoType?> add(String name) async {
    if (await hasAlreadyRegistered(name) == false) {
      return await TodoTypeRepository.create(name);
    }
    return null;
  }

  /// 登録済みのTagのリストを取得する
  ///
  /// 1件も登録されていなければ[]を返す
  static Future<List<TodoType>> fetchRegisteredTodoTypeList() async {
    return await TodoTypeRepository.getAll() ?? [];
  }

  static Future<bool> existsTodoType(TodoType todoType) async {
    return await TodoTypeRepository.get(todoType.todoTypeId) != null;
  }
}
