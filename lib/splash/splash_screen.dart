import 'package:flutter/material.dart';
import 'package:netxus/screens/chat_screen.dart';
import 'package:netxus/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
              child: Image.asset('assets/images/netxus-logo.jpg')),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 50),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Netxus!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 3,),
                Text(
                  'Lightning up life one charge at a time!',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
