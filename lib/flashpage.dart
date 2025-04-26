import 'package:flutter/material.dart';
import 'dart:async'; // For Timer

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key); // Added key parameter

  @override
  SplashScreenState createState() => SplashScreenState(); // Made State class public
}

class SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation controller setup
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _controller.forward(); // Start the animation

    // Timer to go to HomePage after 4 seconds
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('background.png'), // Replace with your actual file
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'AutoStock',
                  style: TextStyle(
                    fontSize: screenWidth * 0.1,
                    fontFamily: 'HachiMaruPop',
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade600,
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  '- Never stock out',
                  style: TextStyle(
                    fontSize: screenWidth * 0.05,
                    fontFamily: 'HachiMaruPop', // corrected typo: both texts should use HachiMaruPop
                    fontStyle: FontStyle.italic,
                    color: Colors.blue.shade700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Dummy HomePage
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key); // Added key parameter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to AutoStock!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
