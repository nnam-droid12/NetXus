import 'package:flutter/material.dart';

class RemoteControl extends StatelessWidget {
  const RemoteControl({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control Your Nexus Product'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/google-ass.jpg',
              width: 300,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'Control your Nexus product with your voice!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                //
              },
              child: const Text('Start using voice control'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                shadowColor: Colors.grey.withOpacity(0.5),
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
