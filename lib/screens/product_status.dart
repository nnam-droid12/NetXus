import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:netxus/screens/energy_usage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class ProductStatus extends StatefulWidget {
  const ProductStatus({Key? key}) : super(key: key);

  @override
  _ProductStatusState createState() => _ProductStatusState();
}
class _ProductStatusState extends State<ProductStatus> {
  late DatabaseReference dbRef;
  double batteryPercent = 0;
  double heating = 12;
  double fan = 15;
  bool dataLoaded = false;
  bool isGeneralActive = true; // Track if the General button is active
  bool isServicesActive = false; // Track if the Services button is active

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('netxus_product');
    dbRef.onValue.listen((event) {
      var snapshot = event.snapshot;
      if (snapshot.value != null) {
        var data = snapshot.value as Map<dynamic, dynamic>;
        setState(() {
          batteryPercent = (data['battery_status'] ?? 0).toDouble();
          dataLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    Color indicatorColor = Colors.red;
    if (dataLoaded) {
      indicatorColor = Color.lerp(Colors.red, Colors.green, batteryPercent / 100) ?? Colors.green;
    }

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: primaryColor,
                      ),
                    ),
                    RotatedBox(
                      quarterTurns: 135,
                      child: Icon(
                        Icons.bar_chart_rounded,
                        color: primaryColor,
                        size: 28,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: CircularPercentIndicator(
                    radius: 60,
                    lineWidth: 14,
                    percent: dataLoaded ? batteryPercent / 100 : 0,
                    progressColor: indicatorColor,
                    center: Text(
                      '${dataLoaded ? batteryPercent.toInt() : 0}%',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text(
                    'Battery percent',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isGeneralActive = true;
                          isServicesActive = false;
                        });
                      },
                      child: _roundedButton(
                        primaryColor: primaryColor,
                        title: 'GENERAL',
                        isActive: isGeneralActive,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isServicesActive = true;
                          isGeneralActive = false;
                        });
                      },
                      child: _roundedButton(
                        primaryColor: primaryColor,
                        title: 'SERVICES',
                        isActive: isServicesActive,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (isGeneralActive) // Render the battery voltage card and heating value card if General tab is active
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'BATTERY VOLTAGE',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Slider(
                              value: fan,
                              onChanged: (newFan) {
                                setState(() => fan = newFan);
                              },
                              max: 50,
                              activeColor: primaryColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('0V'),
                                Text('25V'),
                                Text('50V'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${fan.round()}V', style: TextStyle(color: primaryColor)),
                                SizedBox(),
                                SizedBox(),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'HEATING',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${heating.toStringAsFixed(1)}°C', // Display heating value with one decimal place
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                                ),
                              ],
                            ),
                            Slider(
                              value: heating,
                              onChanged: (newHeating) {
                                setState(() => heating = newHeating);
                              },
                              max: 50,
                              activeColor: primaryColor,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('0°C'),
                                Text('25°C'),
                                Text('50°C'),
                              ],
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  heating = 0;
                                });
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                              ),
                              child: Text(
                                'Cool',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                if (isServicesActive) // Render the EnergyUsageCard if Services tab is active
                  EnergyUsageCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roundedButton({
    required Color primaryColor,
    required String title,
    bool isActive = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 32,
      ),
      decoration: BoxDecoration(
        color: isActive ? primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: primaryColor),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isActive ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
