import 'package:flutter/material.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/common/slidable_tile.dart';
import 'package:imploop/page/task_list/todo/todo_edit_modal.dart';
import 'package:imploop/service/todo_service.dart';

class TodoTile extends StatelessWidget {
  const TodoTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.todo,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return SlidableTile(
      tile: ListTile(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.local_fire_department),
        ),
        title: Text(
          title,
        ),
        subtitle: Text(
          subtitle,
        ),
        trailing: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ),
      editAction: (context) => TodoEditModal.show(context, todo),
      deleteAction: (context) async {
        if (await TodoService.deleteTodo(todo)) {
          // Taskが追加されたことをスナックバーで通知
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Todoが削除されました。',
              ),
            ),
          );
          // 前の画面に遷移
          Navigator.pop(context);
        }
      },
    );
  }
}