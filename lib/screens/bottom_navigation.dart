import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:netxus/screens/home_page.dart';
import 'package:netxus/screens/product_location.dart';
import 'package:netxus/screens/product_status.dart';
import 'package:netxus/screens/remote_control.dart';

class NavBar extends StatefulWidget {
  const NavBar({Key? key}) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  List<Widget> screens = [
    const MyHomePage(),
    const MapPage(),
    const RemoteControl(),
    const ProductStatus(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        index: currentIndex,
        backgroundColor: Colors.white,
        color: Theme.of(context).primaryColor,
        animationDuration: const Duration(milliseconds: 300),
        height: 65,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          Icon(
            Icons.home,
            size: 28,
            color: Colors.white,
          ),
          Icon(
            Icons.location_on, // Changed to a location pin icon
            size: 28,
            color: Colors.white,
          ),
          Icon(
            Icons.settings_remote, // Changed to a remote control icon
            size: 28,
            color: Colors.white,
          ),
          Icon(
            Icons.notifications_active, 
            size: 28,
            color: Colors.white,
          ),
        ],
      ),
      body: screens[currentIndex],
    );
  }
}
