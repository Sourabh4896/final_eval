import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SuccessScreen extends StatefulWidget {
  final String publicKey;
  final String deviceId;
  final String signedData;

  SuccessScreen({
    required this.publicKey,
    required this.deviceId,
    required this.signedData,
  });

  @override
  _SuccessScreenState createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  String statusMessage = "Waiting for server response...";
  double progress = 0.0;

  // Send data to server and handle the response
  Future<void> _sendDataToServer() async {
    setState(() {
      statusMessage = 'Sending data to server...';
      progress = 0.5;
    });

    final url = Uri.parse('http://10.70.73.218:5000/save_data');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'public_key': widget.publicKey,
        'device_id': widget.deviceId,
        'signed_data': widget.signedData,
      }),
    );

    if (response.statusCode == 200) {
      // Once data is sent successfully, check the response from the server
      final responseData = json.decode(response.body);

      if (responseData['status'] == 'authorize') {
        setState(() {
          statusMessage = 'User Authorized!';
          progress = 1.0;
        });

        // Optionally, navigate to the authorized page after success
        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AuthorizedPage()),
          );
        });
      } else if (responseData['status'] == 'processing') {
        setState(() {
          statusMessage = 'Processing your request...';
          progress = 0.8;
        });

        // Wait for some time and then try again, or show a retry button
        Future.delayed(Duration(seconds: 2), () {
          _sendDataToServer(); // Retry if processing
        });
      } else if (responseData['status'] == 'error') {
        setState(() {
          statusMessage = 'Error: ${responseData['message']}';
          progress = 0.0;
        });
      }
    } else {
      setState(() {
        statusMessage = 'Failed to send data: ${response.body}';
        progress = 0.0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Start the process when the screen is loaded
    _sendDataToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sending Data")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display status message
            Text(
              statusMessage,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Progress bar
            AnimatedContainer(
              duration: Duration(seconds: 1),
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey[300],
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),

            // Show retry button or success button depending on the progress
            if (progress < 1.0)
              ElevatedButton(
                onPressed: _sendDataToServer, // Trigger data send again if needed
                child: Text("Retry"),
              ),
            if (progress == 1.0)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Go back to the previous screen
                },
                child: Text("Back to Home"),
              ),
          ],
        ),
      ),
    );
  }
}

class AuthorizedPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Authorized User")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text(
              "You are authorized!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Text("Go Back"),
            ),
          ],
        ),
      ),
    );
  }
}
