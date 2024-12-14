import 'package:flutter/material.dart';
import 'device_id_util.dart';  // Import the DeviceIdUtil class
import './../utils/key_pair_generator.dart';  // Import the RSA key pair generation functionality

class RegisterProcessPage extends StatefulWidget {
  @override
  _RegisterProcessPageState createState() => _RegisterProcessPageState();
}

class _RegisterProcessPageState extends State<RegisterProcessPage> {
  double progress = 0.0;
  int currentStep = 1;
  String deviceId = "Fetching...";  // Initialize deviceId as "Fetching..."
  bool isDeviceIdFetched = false;
  String publicKey = "Generating...";  // Initialize publicKey as "Generating..."
  bool isKeyGenerated = false;  // Track key generation state

  @override
  void initState() {
    super.initState();
    _fetchDeviceId();  // Fetch the device ID when the page loads
    Future.delayed(Duration(seconds: 2), _updateStep);  // Start the process after a delay
  }

  // Fetch device ID using DeviceIdUtil
  Future<void> _fetchDeviceId() async {
    String id = await DeviceIdUtil.getDeviceUniqueId();
    setState(() {
      deviceId = id;
      isDeviceIdFetched = true;  // Mark device ID as fetched
    });
  }

  // Function to update the progress and step
  void _updateStep() {
    setState(() {
      if (currentStep == 1) {
        progress = 0.33;
      } else if (currentStep == 2) {
        progress = 0.66;
        _generateRSAKeyPair();  // Generate RSA key pair during step 2
      } else if (currentStep == 3) {
        progress = 1.0;
      }
      currentStep++;
    });

    // After the 3rd step, show "Registration Successful"
    if (currentStep > 3) {
      setState(() {
        currentStep = 0;  // Reset step to 0 (final state)
      });
    } else {
      // Continue the process after a 2-second delay
      Future.delayed(Duration(seconds: 2), _updateStep);
    }
  }

  // Generate RSA key pair and update the public key
  Future<void> _generateRSAKeyPair() async {
    Map<String, String> keys = await generateRSAKeyPair();
    setState(() {
      if (keys.isNotEmpty) {
        publicKey = keys['publicKey'] ?? "Error generating key";
        isKeyGenerated = true;  // Mark key generation as completed
      } else {
        publicKey = "Error generating key";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration Process"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Step Title with Animation
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: currentStep == 0
                  ? Text(
                      "Registration Successful!",
                      key: ValueKey<int>(currentStep),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    )
                  : Text(
                      "Step $currentStep",
                      key: ValueKey<int>(currentStep),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
            ),
            SizedBox(height: 20),

            // Step Description with Animation
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: currentStep == 1
                  ? Column(
                      children: [
                        Text(
                          "Device ID Verification",
                          key: ValueKey<int>(currentStep),
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 10),
                        // Display the device ID once fetched
                        isDeviceIdFetched
                            ? Text(
                                "Device ID: $deviceId",
                                style: TextStyle(fontSize: 16, color: Colors.green),
                              )
                            : CircularProgressIndicator(),
                      ],
                    )
                  : currentStep == 2
                      ? Column(
                          children: [
                            Text(
                              "Public Key Generation",
                              key: ValueKey<int>(currentStep),
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            // Display the generated public key
                            isKeyGenerated
                                ? Text(
                                    "Public Key: $publicKey",
                                    style: TextStyle(fontSize: 16, color: Colors.green),
                                  )
                                : CircularProgressIndicator(),
                          ],
                        )
                      : currentStep == 3
                          ? Text(
                              "Signing of Data",
                              key: ValueKey<int>(currentStep),
                              style: TextStyle(fontSize: 18),
                            )
                          : Container(),
            ),

            SizedBox(height: 30),

            // Progress Bar
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

            SizedBox(height: 30),

            // Show current step completion status
            AnimatedSwitcher(
              duration: Duration(seconds: 1),
              child: currentStep == 0
                  ? Text(
                      "Registration Completed!",
                      key: ValueKey<int>(currentStep),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                    )
                  : Text(
                      "${(progress * 100).toInt()}% Completed",
                      key: ValueKey<int>(currentStep),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),

            Spacer(),

            // Back to Home button
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to the home page
              },
              child: Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
