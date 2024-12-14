import 'package:flutter/material.dart';
import 'secure_storage_util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SecureStorageScreen(),
    );
  }
}

class SecureStorageScreen extends StatefulWidget {
  @override
  _SecureStorageScreenState createState() => _SecureStorageScreenState();
}

class _SecureStorageScreenState extends State<SecureStorageScreen> {
  String _storedData = "No data stored";

  @override
  void initState() {
    super.initState();
    _fetchStoredData();
  }

  /// Fetches the stored data when the screen is loaded
  Future<void> _fetchStoredData() async {
    String? data = await SecureStorageUtil.fetchData();
    setState(() {
      _storedData = data ?? "No data stored";
    });
  }

  /// Stores data securely
  Future<void> _storeData(String data) async {
    await SecureStorageUtil.storeData(data);
    _fetchStoredData(); // Refresh the stored data after storing
  }

  /// Deletes the stored data securely
  Future<void> _deleteData() async {
    await SecureStorageUtil.deleteData();
    _fetchStoredData(); // Refresh the stored data after deleting
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Secure Storage Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Stored Data:",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              _storedData,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => _storeData("This is secure data!"),
              child: const Text('Store Data'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _deleteData,
              child: const Text('Delete Data'),
            ),
          ],
        ),
      ),
    );
  }
}
