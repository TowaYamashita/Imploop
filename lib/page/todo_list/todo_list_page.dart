import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/service/task_service.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  final int taskId;

  static show(BuildContext context, int taskId) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TodoListPage(taskId: taskId);
        },
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskリスト'),
      ),
      body: _TodoList(
        taskId: taskId,
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _TodoCreatePage.show(context, taskId),
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({Key? key, required this.taskId}) : super(key: key);

  final int taskId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Todo>>(
      future: TaskService.getAllTodoInTask(taskId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final List<Todo>? _todoList = snapshot.data ?? [];
        return ListView.builder(
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                _todoList![index].name.toString(),
              ),
              subtitle: Flexible(
                child: Text(
                  'taskId: ${_todoList[index].taskId} statusId: ${_todoList[index].statusId} estimate: ${_todoList[index].estimate}',
                ),
              ),
            );
          },
          itemCount: _todoList!.length,
        );
      },
    );
  }
}

class _TodoCreatePage extends StatelessWidget {
  _TodoCreatePage({
    Key? key,
    required this.taskId,
  }) : super(key: key);

  static show(BuildContext context, int taskId) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return _TodoCreatePage(taskId: taskId);
        },
        fullscreenDialog: true,
      ),
    );
  }

  final int taskId;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> nameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> estimateKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task入力'),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                key: nameKey,
                decoration: const InputDecoration(
                  labelText: "Todoの名前",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '名前が入力されていません。';
                  }
                  return null;
                },
              ),
              TextFormField(
                key: estimateKey,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(
                  labelText: "このTodoを行うのにかかる時間の見積もり[分]",
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    return '見積もりが入力されていません。';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    final String? _name = nameKey.currentState?.value;
                    final int? _estimate = estimateKey.currentState != null
                        ? int.parse(estimateKey.currentState!.value!)
                        : null;
                    TaskService.registerNewTodo(
                        taskId, _name ?? '', _estimate ?? -1);

                    // Taskが追加されたことをスナックバーで通知
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Todoが追加されました。',
                        ),
                      ),
                    );
                    // 前の画面に遷移
                    Navigator.pop(context);
                  }
                },
                child: const Text('登録する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
