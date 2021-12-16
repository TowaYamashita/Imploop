import 'package:flutter/material.dart';
import 'package:imploop/page/task_list/task_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ホーム'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => TaskListPage.show(context),
          child: const Text('Task・Todo入力画面へ遷移'),
        ),
      ),
    );
  }
}
