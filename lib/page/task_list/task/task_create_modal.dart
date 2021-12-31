import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/task_type.dart';
import 'package:imploop/page/common/carousel_view.dart';
import 'package:imploop/page/task_list/task/recommendation_task_type_input_form.dart';
import 'package:imploop/service/task_service.dart';

class TaskCreateModal extends HookConsumerWidget {
  TaskCreateModal({Key? key}) : super(key: key);

  static show(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TaskCreateModal();
        },
        fullscreenDialog: true,
      ),
    );
  }

  final nameKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        ref.read(selectedTaskTypeProvider.notifier).update((state) => null);
      });
    }, const []);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task入力'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '過去のTaskの振り返り',
              style: Theme.of(context).textTheme.headline5,
            ),
            TaskNoticeCarouselView(
              taskType: ref.read(selectedTaskTypeProvider.notifier).state,
            ),
            Center(
              child: Form(
                child: Column(
                  children: [
                    TextFormField(
                      key: nameKey,
                      decoration: const InputDecoration(
                        labelText: "Taskの名前",
                      ),
                    ),
                    const RecommendationTaskTypeInputForm(),
                    ElevatedButton(
                      onPressed: () async {
                        final String? name = nameKey.currentState?.value;
                        final TaskType? selectedTaskType =
                            ref.read(selectedTaskTypeProvider.notifier).state;
                        late final Task? addedTask;
                        if (name != null && selectedTaskType != null) {
                          addedTask = await TaskService.registerNewTask(
                            name,
                            selectedTaskType,
                          );
                        } else {
                          addedTask = null;
                        }

                        if (addedTask != null) {
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
                        }
                      },
                      child: const Text('登録する'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
