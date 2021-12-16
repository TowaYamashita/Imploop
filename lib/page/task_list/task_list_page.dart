import 'package:flutter/material.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/page/common/slidable_tile.dart';
import 'package:imploop/page/todo_list/todo_list_page.dart';
import 'package:imploop/service/task_service.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({Key? key}) : super(key: key);

  static show(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const TaskListPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskリスト'),
      ),
      body: const _TaskList(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _TaskCreatePage.show(context),
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
            return _TaskTile(
              title: _taskList![index].name.toString(),
              subtitle:
                  'taskId: ${_taskList[index].taskId} statusId: ${_taskList[index].statusId}',
              taskId: _taskList[index].taskId,
            );
          },
          itemCount: _taskList!.length,
        );
      },
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.taskId,
  }) : super(key: key);

  final String title;
  final String subtitle;
  final int taskId;

  @override
  Widget build(BuildContext context) {
    return SlidableTile(
      tile: ListTile(
        title: Text(
          title,
        ),
        subtitle: Text(
          subtitle,
        ),
        trailing: IconButton(
          onPressed: () => TodoListPage.show(
            context,
            taskId,
          ),
          icon: const Icon(Icons.arrow_forward_ios_rounded),
        ),
      ),
      editAction: (context) {},
      deleteAction: (context) {},
    );
  }
}

class _TaskCreatePage extends StatelessWidget {
  const _TaskCreatePage({Key? key}) : super(key: key);

  static show(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const _TaskCreatePage();
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
