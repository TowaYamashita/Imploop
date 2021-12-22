// ignore_for_file: constant_identifier_names

enum TagArgument{
  tag_id,
  name,
}
class Tag {
  const Tag({
    required this.tagId,
    required this.name,
  });

  factory Tag.fromMap(Map<String, dynamic> tag) {
    return Tag(
      tagId: tag[TagArgument.tag_id.name] as int,
      name: tag[TagArgument.name.name] as String,
    );
  }

  final int tagId;
  final String name;
}
