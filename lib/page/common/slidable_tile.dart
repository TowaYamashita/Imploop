import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SlidableTile extends StatelessWidget {
  const SlidableTile({
    Key? key,
    required this.tileTitle,
    required this.editAction,
    required this.deleteAction,
  }) : super(key: key);

  final String tileTitle;
  final void Function(BuildContext context) editAction;
  final void Function(BuildContext context) deleteAction;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            // flex: 2,
            onPressed: editAction,
            backgroundColor: Color(0xFF439DC0),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: '編集',
          ),
          SlidableAction(
            onPressed: deleteAction,
            backgroundColor: Color(0xFFFF0000),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: '削除',
          ),
        ],
      ),

      child: ListTile(title: Text(tileTitle)),
    );
  }
}
