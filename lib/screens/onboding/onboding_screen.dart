import 'dart:async';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import '../../screens/entry_point.dart'; // Import your Slide3Screen widget here

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    super.initState();
    _btnAnimationController = SimpleAnimation("active");
    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const EntryPoint(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              "assets/Backgrounds/logo.png",
              height: 30, // Set your desired height here
              width: 60, // Set your desired width here
            ),
          ),
          // Add your other widgets and animations here
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: OnboardingScreen(),
  ));
}
