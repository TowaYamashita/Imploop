import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:imploop/domain/todo_notice.dart';
import 'package:imploop/domain/todo_type.dart';
import 'package:imploop/service/todo_notice_service.dart';

class TodoNoticeCarouselView extends HookWidget {
  const TodoNoticeCarouselView({
    Key? key,
    this.todoType,
  }) : super(key: key);

  final TodoType? todoType;

  List<Widget> getItems(List<TodoNotice> todoNoticeList) {
    return todoNoticeList.map((todoNotice) {
      return Builder(
        builder: (context) {
          return GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("振り返り"),
                    content: Text(
                      todoNotice.body,
                      textAlign: TextAlign.start,
                    ),
                  );
                },
              );
            },
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                width: double.maxFinite,
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todoNotice.body,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                    const Text(
                      'タップして詳細を見る',
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final AsyncSnapshot<List<TodoNotice>> _snapshot =
        useFuture(TodoNoticeService.getTodoNoticeListByTodoType(todoType));
    if (!_snapshot.hasData) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }
    final List<TodoNotice> todoNoticeList = _snapshot.data!;

    final carouselCardList = getItems(todoNoticeList);
    return CarouselSlider(
      options: CarouselOptions(),
      items: carouselCardList,
    );
  }
}

class TaskNoticeCarouselCardList extends StatelessWidget {
  const TaskNoticeCarouselCardList({
    Key? key,
    this.taskTypeId,
  }) : super(key: key);

  final int? taskTypeId;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TodoNoticeCarouselCard extends StatelessWidget {
  const TodoNoticeCarouselCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class TaskNoticeCarouselCard extends StatelessWidget {
  const TaskNoticeCarouselCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
