import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/page/timer/timer_page.dart';
import 'package:imploop/service/todo_type_service.dart';
import 'package:imploop/service/todo_notice_service.dart';

class TodoNoticePage extends HookWidget {
  TodoNoticePage({
    Key? key,
    required this.todo,
  }) : super(key: key);

  static show(
    BuildContext context,
    Todo todo,
  ) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TodoNoticePage(
            todo: todo,
          );
        },
        fullscreenDialog: true,
      ),
    );
  }

  final Todo todo;
  final noticeFormKey = GlobalKey<FormFieldState<String>>();

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<TodoType?> tagProvider = useState<TodoType?>(null);
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
              _TagArea(provider: tagProvider),
              _SubmitButton(
                todo: todo,
                noticeFormKey: noticeFormKey,
                provider: tagProvider,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('振り返り'),
        TextFormField(
          key: formKey,
          initialValue: '',
          keyboardType: TextInputType.text,
        ),
      ],
    );
  }
}

/// 振り返りに付けるタグを入力・選択する
class _TagArea extends StatelessWidget {
  _TagArea({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final tagFormKey = GlobalKey<FormFieldState<String>>();
  final ValueNotifier<TodoType?> provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('タグ'),
        TextFormField(
          key: tagFormKey,
          onEditingComplete: () async {
            if (tagFormKey.currentState != null &&
                tagFormKey.currentState!.value != null) {
              final TodoType? newTag =
                  await TodoTypeService.add(tagFormKey.currentState!.value!);
              if (newTag != null) {
                provider.value = newTag;
              }
            }
          },
        ),
      ],
    );
  }
}

/// フォームのサブミットボタン
///
/// これを押下したら振り返りの保存処理を走らせる
class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    Key? key,
    required this.todo,
    required this.noticeFormKey,
    required this.provider,
  }) : super(key: key);

  final Todo todo;
  final GlobalKey<FormFieldState<String>> noticeFormKey;
  final ValueNotifier<TodoType?> provider;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final String notice = noticeFormKey.currentState != null
            ? noticeFormKey.currentState!.value ?? ''
            : '';
        final TodoType tag = provider.value!;
        if (await TodoNoticeService.register(todo, tag, notice)) {
          TimerPage.show(context);
        }
      },
      child: const Text('振り返りを記録する'),
    );
  }
}
