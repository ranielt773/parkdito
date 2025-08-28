import 'package:flutter/material.dart';
import 'dart:async';
import 'package:slide_to_act/slide_to_act.dart';
import 'login.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});
  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen>
    with TickerProviderStateMixin {
  late final AnimationController _carController;
  late final Animation<double> _carAAnimation;
  late final Animation<double> _carBAnimation;

  @override
  void initState() {
    super.initState();
    _carController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _carAAnimation = Tween<double>(begin: -250, end: 80).animate(
      CurvedAnimation(parent: _carController, curve: Curves.easeInOut),
    );

    _carBAnimation = Tween<double>(begin: 250, end: -80).animate(
      CurvedAnimation(parent: _carController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _carController.dispose();
    super.dispose();
  }

  // 🚀 Pagkatapos ng animation, diretso na sa LoginScreen
  Future<void> _onSlideComplete() async {
    await _carController.forward(); // play animation

    await Future.delayed(const Duration(milliseconds: 300)); // konting delay
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Logo
            Image.asset('assets/logo.png', width: 200),
            const SizedBox(height: 10),
            const Spacer(),

            // Cars animation
            AnimatedBuilder(
              animation: _carController,
              builder: (context, _) => Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Transform.translate(
                  offset: Offset(_carBAnimation.value, -10),
                  child: Image.asset("assets/carb.png", width: 290),
                 ),
                  Transform.translate(
                    offset: Offset(_carAAnimation.value, 0),
                    child: Image.asset("assets/cara.png", width: 320),


                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Text("Park smarter, not harder.",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 30),

            // Slide to Start
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: SlideAction(
                borderRadius: 15,
                sliderButtonIconPadding: 23,
                elevation: 2,
                innerColor: Color(0xFF3B060A),
                outerColor: Color(0xFFFAE995),
                sliderButtonIcon:
                const Icon(Icons.arrow_forward, color: Color(0xFFF7DC56),),
                text: "Getting Started",
                textStyle: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
                onSubmit: _onSlideComplete,
              ),
            ),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}
