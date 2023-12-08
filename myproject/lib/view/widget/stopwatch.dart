import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';


class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  StopWatchState createState() => StopWatchState();
}

class StopWatchState extends State<StopWatch> {
  final _stopWatch = Stopwatch();
  final _stopWatchObservable = BehaviorSubject<int>();
  final _lapTimes = <String>[];

  @override
  void dispose() {
    super.dispose();
    _stopWatchObservable.close();
  }

  void _startStopButtonPressed() async {
    if (_stopWatch.isRunning) {
      _stopWatch.stop();
    } else {
      _stopWatch.start();
      await for (var tick in Stream.periodic(Duration(milliseconds: 10))) {
        _stopWatchObservable.add(_stopWatch.elapsedMilliseconds);
        if (!_stopWatch.isRunning) break;
      }
    }

    setState(() {});
  }

  void _resetButtonPressed() {
    _stopWatch.reset();
    _stopWatchObservable.add(0);
    _lapTimes.clear();
    setState(() {});
  }

  void _recordLapTime() {
    final milliseconds = _stopWatch.elapsedMilliseconds;
    final displayTime = Duration(milliseconds: milliseconds);
    _lapTimes.add(displayTime.toString().substring(2, 7));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Display stopwatch time
          StreamBuilder<int>(
            stream: _stopWatchObservable.stream,
            builder: (context, snapshot) {
              final value = snapshot.data ?? 0;
              final displayTime = Duration(milliseconds: value);
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  displayTime.toString().substring(2, 7),
                  style: const TextStyle(fontSize: 40),
                ),
              );
            },
          ),
          // Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: _startStopButtonPressed,
                child: Text(_stopWatch.isRunning ? 'Stop' : 'Start'),
              ),
              ElevatedButton(
                onPressed: _resetButtonPressed,
                child: const Text('Reset'),
              ),
              ElevatedButton(
                onPressed: _recordLapTime,
                child: const Text('Record'),
              ),
            ],
          ),
          // Display lap times
          Expanded(
            child: ListView.builder(
              itemCount: _lapTimes.length,
              itemBuilder: (context, index) => Text(
                'Lap ${index + 1}: ${_lapTimes[index]}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}