import 'dart:async';
import 'package:flutter/material.dart';
import 'stopwatch_painter.dart';

class StopwatchPage extends StatefulWidget {
  @override
  _StopwatchPageState createState() => _StopwatchPageState();
}

class _StopwatchPageState extends State<StopwatchPage> with SingleTickerProviderStateMixin {
  late Stopwatch _stopwatch;
  late Timer _timer;
  late AnimationController _animationController;

  final Duration _maxDuration = Duration(minutes: 1); // Defining the maximum duration

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _animationController = AnimationController(vsync: this, duration: _maxDuration)
      ..addListener(() {
        setState(() {});
      });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      if (_stopwatch.isRunning) {
        // Calculate progress as a fraction of elapsed time over the maximum duration
        double progress = _stopwatch.elapsedMilliseconds / _maxDuration.inMilliseconds;
        _animationController.value = progress;
      }
    });
  }

  void _startStopwatch() {
    _stopwatch.start();
    _startTimer();
    _animationController.forward();
  }

  void _stopStopwatch() {
    _stopwatch.stop();
    _timer.cancel();
    _animationController.stop();
  }

  void _resetStopwatch() {
    _stopwatch.reset();
    setState(() {});
    _animationController.value = 0.0;
  }

  String _formatTime(int milliseconds) {
    int minutes = (milliseconds ~/ 60000);
    int seconds = (milliseconds ~/ 1000) % 60;
    int millis = (milliseconds % 1000) ~/ 10;

    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}:'
        '${millis.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Prodigy InfoTech Stopwatch',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 50),
            Container(
              width: 200,
              height: 200,
              child: CustomPaint(
                painter: StopwatchPainter(
                  _animationController.value,
                  _formatTime(_stopwatch.elapsedMilliseconds),
                ),
              ),
            ),
            SizedBox(height: 80),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  onPressed: _stopwatch.isRunning ? _stopStopwatch : _startStopwatch,
                  icon: Icon(_stopwatch.isRunning ? Icons.pause : Icons.play_arrow),
                  label: Text(_stopwatch.isRunning ? 'Pause' : 'Start'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: _resetStopwatch,
                  icon: Icon(Icons.refresh),
                  label: Text('Reset'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50), // Add space at the bottom
          ],
        ),
      ),
    );
  }
}
