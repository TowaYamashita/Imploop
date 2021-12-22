// ignore_for_file: constant_identifier_names

enum TodoNoticeArgument {
  todo_notice_id,
  todo_id,
  tag_id,
  body,
}

class TodoNotice {
  TodoNotice({
    required this.todoNoticeId,
    required this.todoId,
    required this.tagId,
    required this.body,
  });

  factory TodoNotice.fromMap(Map<String, dynamic> todoNotice) {
    return TodoNotice(
      todoNoticeId: todoNotice[TodoNoticeArgument.todo_notice_id] as int,
      todoId: todoNotice[TodoNoticeArgument.todo_id] as int,
      tagId: todoNotice[TodoNoticeArgument.tag_id] as int,
      body: todoNotice[TodoNoticeArgument.body] as String,
    );
  }

  final int todoNoticeId;
  final int todoId;
  final int tagId;
  final String body;
}
