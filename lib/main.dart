import 'package:flutter/material.dart';
import 'dart:async';
import 'OpeningScreen.dart';

void main() {
  runApp(const ParkDittoApp());
}

class ParkDittoApp extends StatelessWidget {
  const ParkDittoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Wait 2 seconds then go to Opening Screen
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OpeningScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [Colors.white, Color(0xFFFFD54F)],
          ),
        ),
        child: Center(
          child: Image.asset(
            'lib/assets/logo.png',
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}
