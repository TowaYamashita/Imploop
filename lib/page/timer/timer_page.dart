import 'package:flutter/material.dart';
import 'package:imploop/page/common/count_up_timer.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({Key? key}) : super(key: key);

  static show(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return const TimerPage();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
          )
        ],
      ),
    );
  }
}
