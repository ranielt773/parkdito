import 'package:flutter/material.dart';
import 'dart:async';
import 'OpeningScreen.dart';
import 'login.dart';
import 'mainpage.dart';
import 'api/api_service.dart';

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
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    bool isLoggedIn = await ApiService.isLoggedIn();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      if (isLoggedIn) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const OpeningScreen()),
        );
      }
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
            'assets/logo.png',
            width: 250,
            height: 250,
          ),
        ),
      ),
    );
  }
}