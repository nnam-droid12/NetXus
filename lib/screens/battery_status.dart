import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  late DatabaseReference dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('netxus_product');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Data'),
      ),
      body: StreamBuilder<DatabaseEvent>(
        stream: dbRef.onValue,
        builder: (BuildContext context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            Map<dynamic, dynamic>? data =
                dataSnapshot.value as Map<dynamic, dynamic>?;

            if (data != null) {
              return Stack(
                children: [
                  // Background container
                  Container(
                    color: Colors.white, // White background for the entire page
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  // Content column
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Avoid unnecessary space
                      children: [
                        // Live Battery Status
                        Text(
                          'Live Battery Status',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.green),
                        ),
                        const SizedBox(height: 10), // Add spacing
                        // Circular battery status with yellow background
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.yellow,
                              ),
                            ),
                            Text(
                              '${data['battery_status']}%',
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10), // Add spacing
                        // Device type and voltage row with yellow background
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.yellow, // Yellow background
                                border: Border.all(
                                    color: Colors.yellow), // Yellow border
                              ),
                              child: Text(
                                'Device Type: ${data['deviceType']}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.yellow, // Yellow background
                                border: Border.all(
                                    color: Colors.yellow), // Yellow border
                              ),
                              child: Text(
                                'Voltage: ${data['voltage']}V',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          }
          return Center(
            child: Text('No product data available'),
          );
        },
      ),
    );
  }
}
