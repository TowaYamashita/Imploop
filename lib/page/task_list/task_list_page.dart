import 'package:flutter/material.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/page/task_list/task/task_create_modal.dart';
import 'package:imploop/page/task_list/task/task_tile.dart';
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
        onPressed: () => TaskCreateModal.show(context),
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
            return TaskTile(
              title: _taskList![index].name.toString(),
              subtitle:
                  'taskId: ${_taskList[index].taskId} statusId: ${_taskList[index].statusId}',
              task: _taskList[index],
            );
          },
          itemCount: _taskList!.length,
        );
      },
    );
  }
}
