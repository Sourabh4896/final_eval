import 'package:flutter/material.dart';
import 'device_model_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeviceModelScreen(),
    );
  }
}

class DeviceModelScreen extends StatefulWidget {
  @override
  _DeviceModelScreenState createState() => _DeviceModelScreenState();
}

class _DeviceModelScreenState extends State<DeviceModelScreen> {
  String _deviceModelId = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchDeviceModelId();
  }

  /// Fetches the device model ID and updates the UI.
  Future<void> _fetchDeviceModelId() async {
    final modelId = await DeviceModelUtil.getDeviceModelId();
    setState(() {
      _deviceModelId = modelId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Device Model ID'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Device Model ID:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Text(
              _deviceModelId,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchDeviceModelId,
              child: const Text('Get Device Model'),
            ),
          ],
        ),
      ),
    );
  }
}
