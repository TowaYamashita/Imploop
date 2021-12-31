import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imploop/domain/task.dart';
import 'package:imploop/domain/todo.dart';
import 'package:imploop/domain/todo_timer.dart';
import 'package:imploop/page/common/count_up_timer.dart';
import 'package:imploop/page/task_list/task/task_create_modal.dart';
import 'package:imploop/page/todo_notice/todo_notice_page.dart';
import 'package:imploop/service/task_service.dart';
import 'package:imploop/service/todo_service.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key, this.selectedTodo}) : super(key: key);

  final Todo? selectedTodo;

  static show(BuildContext context, {Todo? selectedTodo}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return TimerPage(
            selectedTodo: selectedTodo,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('タイマー'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CountUpTimer(
            stopWatchTimer: stopWatchTimer,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CountUpTimerStartButton(
                stopWatchTimer: stopWatchTimer,
              ),
              CountUpTimerStopButton(
                stopWatchTimer: stopWatchTimer,
              ),
              CountUpTimerResetButton(
                stopWatchTimer: stopWatchTimer,
              ),
            ],
          ),
          selectedTodo == null
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const TaskSelectorDialog();
                      },
                    );
                  },
                  child: const Text('やるtodoを選択する'),
                )
              : ElevatedButton(
                  onPressed: () async {
                    final int elapsedMinute =
                        TodoTimer(stopWatchTimer).elapsedMinutes();
                    if (await TodoService.finishTodo(
                      selectedTodo!,
                      elapsedMinute,
                    )) {
                      TodoNoticePage.show(
                        context,
                        (await TodoService.getTodo(selectedTodo!.todoId))!,
                      );
                    }
                  },
                  child: Text(
                    "${selectedTodo!.name}を完了させる",
                  ),
                )
        ],
      ),
    );
  }
}

class TaskSelectorDialog extends HookWidget {
  const TaskSelectorDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _snapshot = useFuture(TaskService.getAllTaskWithoutFinished());
    if (!_snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final List<Task> allTaskList = _snapshot.data!;
    return allTaskList.isEmpty
        ? AlertDialog(
            title: Text('選択できるTaskがありません'),
            content: ElevatedButton(
              onPressed: () {
                TaskCreateModal.show(context);
              },
              child: Text('Taskを作成する'),
            ),
          )
        : SimpleDialog(
            title: const Text('Todoを選択'),
            children: [
              for (final task in allTaskList)
                SimpleDialogTaskListTile(task: task),
            ],
          );
  }
}

class SimpleDialogTaskListTile extends HookWidget {
  const SimpleDialogTaskListTile({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    final _future = useMemoized(
        () => TaskService.getAllTodoWithoutFinishedInTask(task.taskId));
    final _snapshot = useFuture(_future);
    if (_snapshot.connectionState != ConnectionState.done) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    final List<Todo> allTodoListInTask = _snapshot.data!;
    final _visible = useState<bool>(false);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(task.name),
          onTap: () {
            _visible.value = !_visible.value;
          },
        ),
        Visibility(
          visible: _visible.value,
          child: Column(
            children: [
              for (final Todo todo in allTodoListInTask)
                SimpleDialogTodoListTile(todo: todo)
            ],
          ),
        ),
      ],
    );
  }
}

class SimpleDialogTodoListTile extends StatelessWidget {
  const SimpleDialogTodoListTile({Key? key, required this.todo})
      : super(key: key);

  final Todo todo;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        TimerPage.show(context, selectedTodo: todo);
      },
      child: Container(
        width: double.infinity,
        child: Text(todo.name),
      ),
    );
  }
}
