import 'package:flutter/material.dart';
import 'package:netxus/battery_status.dart';
import 'package:netxus/remote_control.dart';
// import 'package:notchai_frontend/screens/game.dart';
import 'package:netxus/product_location.dart';
import 'package:netxus/home_page.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentpageIndex = 0;
  final List<Widget> _widgetScreen = <Widget>[
    const MyHomePage(),
    const ProductLocation(),
    const RemoteControl(),
    const FetchData(),
  ];

  void initTapIcon(int index) {
    setState(() {
      currentpageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetScreen[currentpageIndex],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 8,
        onTap: initTapIcon,
        currentIndex: currentpageIndex,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color.fromARGB(255, 11, 140, 123),
        unselectedItemColor:
            const Color(0xff00c6ad), // Changed unselected color to grey
        items: [
          _buildNavBarItem(Icons.home, "Home", 0),
          _buildNavBarItem(Icons.scanner_rounded, "Location", 1),
          _buildNavBarItem(Icons.map_outlined, "Assistant", 2),
          _buildNavBarItem(Icons.map_outlined, "Status", 3),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildNavBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          Icon(icon),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      label: "", // Set label to empty string to hide default label
      activeIcon: Column(
        children: [
          Icon(icon),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}
