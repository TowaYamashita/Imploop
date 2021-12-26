import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/task_list/todo/recommendation_todo_type_input_form.dart';
import 'package:imploop/service/todo_service.dart';

class TodoEditModal extends ConsumerWidget {
  TodoEditModal({Key? key, required this.todo}) : super(key: key);

  static show(BuildContext context, Todo todo) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TodoEditModal(todo: todo);
        },
        fullscreenDialog: true,
      ),
    );
  }

  final Todo todo;
  final GlobalKey<FormFieldState<String>> nameKey =
      GlobalKey<FormFieldState<String>>();
  final GlobalKey<FormFieldState<String>> estimateKey =
      GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          child: Column(
            children: [
              TextFormField(
                key: nameKey,
                initialValue: todo.name,
              ),
              TextFormField(
                key: estimateKey,
                initialValue: todo.estimate.toString(),
              ),
              RecommendationTodoTypeInputForm(
                todo: todo,
              ),
              ElevatedButton(
                onPressed: () async {
                  String? updatedName = nameKey.currentState != null
                      ? nameKey.currentState!.value
                      : null;
                  int? updatedEstimate = estimateKey.currentState != null
                      ? int.parse(estimateKey.currentState!.value ?? '0')
                      : null;
                  final selectedTodoType =
                      ref.read(selectedTodoTypeProvider.notifier).state;
                  if (updatedName != null &&
                      updatedEstimate != null &&
                      selectedTodoType != null) {
                    final updatedTodo = todo.copyWith(
                      name: updatedName,
                      estimate: updatedEstimate,
                      todoTypeId: selectedTodoType.todoTypeId,
                    );
                    if (await TodoService.editTodo(updatedTodo)) {
                      // Todoが追加されたことをスナックバーで通知
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Todoが変更されました。",
                          ),
                        ),
                      );
                      // 前の画面に遷移
                      Navigator.pop(context);
                    }
                  }
                },
                child: const Text('変更する'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
