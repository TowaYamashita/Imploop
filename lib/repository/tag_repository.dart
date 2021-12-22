import 'package:imploop/domain/tag.dart';
import 'package:imploop/repository/database_provider.dart';

class TagRepository{
  static String table = 'tag';
  static DBProvider instance = DBProvider.instance;
  
  /// Tagを新規追加する
  static Future<Tag> create(String name) async {
    final Map<String, String> row = {
      "name": name,
    };

    final db = await instance.database;
    final id = await db.insert(table, row);

    return Tag(
      tagId: id,
      name: name,
    );
  }

  /// Tagを取得する
  static Future<List<Tag>?> getAll() async {
    final db = await instance.database;
    final rows =
        await db.rawQuery('SELECT * FROM $table');
    if (rows.isEmpty) return null;

    final List<Tag> allTag = [];
    for (Map<String, dynamic> element in rows) {
      final Tag tag = Tag.fromMap(element);
      allTag.add(tag);
    }
    return allTag;
  }
}