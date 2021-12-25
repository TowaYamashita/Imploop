import 'package:flutter/material.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/service/task_service.dart';

class TaskCreateModal extends StatelessWidget {
  const TaskCreateModal({Key? key}) : super(key: key);

  static show(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const TaskCreateModal();
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task入力'),
      ),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextField(
                onSubmitted: (value) async {
                  final Task addedTask =
                      await TaskService.registerNewTask(value);
                  // Taskが追加されたことをスナックバーで通知
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "${addedTask.name}が追加されました。",
                      ),
                    ),
                  );
                  // 前の画面に遷移
                  Navigator.pop(context);
                },
              ),
              ElevatedButton(
                onPressed: () => {},
                child: const Text('登録する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}