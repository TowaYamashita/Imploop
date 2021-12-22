import 'package:imploop/domain/tag.dart';
import 'package:imploop/repository/tag_repository.dart';

class TagService {
  /// 新しく登録しようとしているタグの名前がすでに登録されていないか判定する
  ///
  /// すでに登録されていればtrue、そうでなければfalseを返す
  static Future<bool> hasAlreadyRegistered(String name) async {
    final List<Tag> registeredTagList = await TagRepository.getAll() ?? [];
    return registeredTagList
        .where((registeredTag) => registeredTag.name == name)
        .isNotEmpty;
  }

  /// 新しいTagを登録する
  ///
  /// 登録することができれば新しく登録したTagのデータを持つTagクラスを
  ///
  /// 登録できなければ、nullを返す
  static Future<Tag?> add(String name) async {
    if (await hasAlreadyRegistered(name) == false) {
      return await TagRepository.create(name);
    }
    return null;
  }

  /// 登録済みのTagのリストを取得する
  ///
  /// 1件も登録されていなければ[]が返す
  static Future<List<Tag>> fetchRegisteredTagList() async {
    return await TagRepository.getAll() ?? [];
  }

  static Future<bool> existsTag(Tag tag) async {
    return await TagRepository.get(tag.tagId) != null;
  }
}
