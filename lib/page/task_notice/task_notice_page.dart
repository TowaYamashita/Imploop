import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/page/timer/timer_page.dart';
import 'package:imploop/service/task_notice_service.dart';

class TaskNoticePage extends HookWidget {
  TaskNoticePage({
    Key? key,
    required this.task,
  }) : super(key: key);

  static show(
    BuildContext context,
    Task task,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TaskNoticePage(
            task: task,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  final Task task;
  final noticeFormKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NoticeFormArea(
                formKey: noticeFormKey,
              ),
              _SubmitButton(
                task: task,
                noticeFormKey: noticeFormKey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 振り返りを記載する入力フォーム
class _NoticeFormArea extends StatelessWidget {
  const _NoticeFormArea({
    Key? key,
    required this.formKey,
  }) : super(key: key);

  final GlobalKey<FormFieldState<String>> formKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('タスクの振り返り'),
          TextFormField(
            key: formKey,
            initialValue: '',
            keyboardType: TextInputType.multiline,
            minLines: 5,
            maxLines: 20,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// フォームのサブミットボタン
///
/// これを押下したら振り返りの保存処理を走らせる
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
    required this.task,
    required this.noticeFormKey,
  }) : super(key: key);

  final Task task;
  final GlobalKey<FormFieldState<String>> noticeFormKey;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final String notice = noticeFormKey.currentState != null
            ? noticeFormKey.currentState!.value ?? ''
            : '';
        if (await TaskNoticeService.register(task, notice)) {
          TimerPage.show(context);
        }
      },
      child: const Text('振り返りを記録する'),
    );
  }
}
