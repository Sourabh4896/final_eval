import 'package:flutter/material.dart';

class RegisterProcessPage extends StatefulWidget {
  @override
  _RegisterProcessPageState createState() => _RegisterProcessPageState();
}

class _RegisterProcessPageState extends State<RegisterProcessPage> {
  double progress = 0.0;
  int currentStep = 1;

  @override
  void initState() {
    super.initState();
    // Start the registration process after a delay (simulating real steps)
    Future.delayed(Duration(seconds: 1), _updateStep);
  }

  // Function to update the progress and step
  void _updateStep() {
    setState(() {
      if (currentStep == 1) {
        progress = 0.33;
      } else if (currentStep == 2) {
        progress = 0.66;
      } else if (currentStep == 3) {
        progress = 1.0;
      }
      currentStep++;
    });

    // Continue the process after some delay
    if (currentStep <= 3) {
      Future.delayed(Duration(seconds: 2), _updateStep);
    }
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
              child: Text(
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
                  ? Text(
                      "Device ID Verification",
                      key: ValueKey<int>(currentStep),
                      style: TextStyle(fontSize: 18),
                    )
                  : currentStep == 2
                      ? Text(
                          "Public Key Generation",
                          key: ValueKey<int>(currentStep),
                          style: TextStyle(fontSize: 18),
                        )
                      : Text(
                          "Signing of Data",
                          key: ValueKey<int>(currentStep),
                          style: TextStyle(fontSize: 18),
                        ),
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
              child: Text(
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
