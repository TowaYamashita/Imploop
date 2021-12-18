import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

/// カウントアップするタイマー
///
/// タイマーの操作は`CountUpTimerStartButton`や`CountUpTimerStartButton`を使用する
class CountUpTimer extends StatefulWidget {
  const CountUpTimer({Key? key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<CountUpTimer> {
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
    onChange: (value) {},
    onChangeRawSecond: (value) {},
    onChangeRawMinute: (value) {},
  );

  @override
  void initState() {
    super.initState();
    _stopWatchTimer.rawTime.listen((value) {});
    _stopWatchTimer.minuteTime.listen((value) {});
    _stopWatchTimer.secondTime.listen((value) {});
    _stopWatchTimer.records.listen((value) {});
  }

  @override
  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: StreamBuilder<int>(
              stream: _stopWatchTimer.rawTime,
              initialData: _stopWatchTimer.rawTime.value,
              builder: (context, snap) {
                final value = snap.data!;
                final displayTime =
                    StopWatchTimer.getDisplayTime(value, milliSecond: false);
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        displayTime,
                        style: const TextStyle(
                          fontSize: 40,
                          fontFamily: 'Helvetica',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          CountUpTimerStartButton(
            stopWatchTimer: _stopWatchTimer,
          ),
          CountUpTimerStopButton(
            stopWatchTimer: _stopWatchTimer,
          ),
          CountUpTimerResetButton(
            stopWatchTimer: _stopWatchTimer,
          )
        ],
      ),
    );
  }
}

/// `CountUpTimer`のタイマーを開始させるボタン
class CountUpTimerStartButton extends StatelessWidget {
  const CountUpTimerStartButton({
    Key? key,
    required this.stopWatchTimer,
    this.buttonText = 'Start',
  }) : super(key: key);

  final StopWatchTimer stopWatchTimer;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 4),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.primary,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          const StadiumBorder(),
        ),
      ),
      onPressed: () async {
        stopWatchTimer.onExecute.add(StopWatchExecute.start);
      },
      child: Text(
        buttonText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

/// `CountUpTimer`のタイマーを停止させるボタン
class CountUpTimerStopButton extends StatelessWidget {
  const CountUpTimerStopButton({
    Key? key,
    required this.stopWatchTimer,
    this.buttonText = 'Stop',
  }) : super(key: key);

  final StopWatchTimer stopWatchTimer;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 4),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.error,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          const StadiumBorder(),
        ),
      ),
      onPressed: () async {
        stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      },
      child: Text(
        buttonText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}

/// `CountUpTimer`のタイマーをリセットさせるボタン
class CountUpTimerResetButton extends StatelessWidget {
  const CountUpTimerResetButton({
    Key? key,
    required this.stopWatchTimer,
    this.buttonText = 'Reset',
  }) : super(key: key);

  final StopWatchTimer stopWatchTimer;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsets>(
          const EdgeInsets.symmetric(horizontal: 4),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
          Theme.of(context).colorScheme.secondary,
        ),
        shape: MaterialStateProperty.all<OutlinedBorder>(
          const StadiumBorder(),
        ),
      ),
      onPressed: () async {
        stopWatchTimer.onExecute.add(StopWatchExecute.reset);
      },
      child: Text(
        buttonText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
