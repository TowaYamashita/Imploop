import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:imploop/page/task_list/task_list_page.dart';
import 'package:imploop/page/timer/timer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  static const pageList = [
    TimerPage(),
    TaskListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        showElevation: true,
        itemCornerRadius: 24,
        curve: Curves.easeIn,
        onItemSelected: (index) => setState(() => _currentIndex = index),
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
            icon: const Icon(Icons.timer),
            title: const Text('タイマー'),
            activeColor: Theme.of(context).colorScheme.primaryVariant,
            textAlign: TextAlign.center,
          ),
          BottomNavyBarItem(
            icon: const Icon(Icons.add_task),
            title: const Text('Task一覧'),
            activeColor: Theme.of(context).colorScheme.primaryVariant,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
