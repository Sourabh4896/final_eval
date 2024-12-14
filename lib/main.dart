import 'package:flutter/material.dart';
import 'time_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TimeScreen(),
    );
  }
}

class TimeScreen extends StatefulWidget {
  @override
  _TimeScreenState createState() => _TimeScreenState();
}

class _TimeScreenState extends State<TimeScreen> {
  int _currentTimeInMilliseconds = 0;

  @override
  void initState() {
    super.initState();
    _fetchCurrentTime();
  }

  /// Fetches the current time in milliseconds and updates the UI.
  void _fetchCurrentTime() {
    setState(() {
      _currentTimeInMilliseconds = TimeUtil.getCurrentTimeInMilliseconds();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Time in Milliseconds'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Current Time in Milliseconds:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              _currentTimeInMilliseconds.toString(),
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchCurrentTime,
              child: const Text('Get Current Time'),
            ),
          ],
        ),
      ),
    );
  }
}
