import 'package:flutter/material.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/service/task_service.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskリスト'),
      ),
      body: const _TaskList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return const _TaskCreatePage();
              },
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }
}

class _TaskList extends StatelessWidget {
  const _TaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Task>>(
      future: TaskService.getAllTask(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Task>? _taskList = snapshot.data ?? [];
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _taskList![index].name.toString(),
              ),
              subtitle: Text(
                'taskId: ${_taskList[index].taskId} statusId: ${_taskList[index].statusId}',
              ),
            );
          },
          itemCount: _taskList!.length,
        );
      },
    );
  }
}

class _TaskCreatePage extends StatelessWidget {
  const _TaskCreatePage({Key? key}) : super(key: key);

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
                        'Taskが追加されました。',
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
