import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';
import 'package:imploop/service/task_service.dart';

class TodoCreateModal extends ConsumerWidget {
  TodoCreateModal({
    Key? key,
    required this.task,
  }) : super(key: key);

  static show(BuildContext context, Task task) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TodoCreateModal(task: task);
        },
        fullscreenDialog: true,
      ),
    );
  }

  final Task task;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState<String>> nameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> estimateKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo入力'),
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
              const RecommendationTodoTypeInputForm(),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState != null &&
                      formKey.currentState!.validate()) {
                    final selectedTodoType =
                        ref.read(selectedTodoTypeProvider.notifier).state;
                    final String? _name = nameKey.currentState?.value;
                    final int? _estimate = estimateKey.currentState != null
                        ? int.parse(estimateKey.currentState!.value!)
                        : null;
                    late final Todo? addedTodo;
                    if (_name != null &&
                        _estimate != null
                        ) {
                      addedTodo = await TaskService.registerNewTodo(
                        task,
                        _name,
                        _estimate,
                        selectedTodoType,
                      );
                    } else {
                      addedTodo = null;
                    }

                    // Todoが追加されたことをスナックバーで通知
                    if (addedTodo != null) {
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
