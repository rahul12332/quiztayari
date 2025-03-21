import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../core/contant/appColor.dart';
import '../core/routes.dart';
import '../domain/sharedPre.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Animation<double>? _animation;
  late List<String> _textLetters;
  late List<Animation<double>> _letterAnimations;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    // Split the text into individual letters
    _textLetters = "Fast Quiz Tayari".split('');

    _controller = AnimationController(
      duration: const Duration(seconds: 7), // Total animation duration
      vsync: this,
    );

    // Create animations for each letter
    _letterAnimations = _textLetters.map((letter) {
      final index = _textLetters.indexOf(letter);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (index / _textLetters.length), // Start time for each letter
            ((index + 1) / _textLetters.length), // End time for each letter
            curve: Curves.easeInOut,
          ),
        ),
      );
    }).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      double screenWidth = MediaQuery.of(context).size.width;

      setState(() {
        _animation = Tween<double>(
          begin: screenWidth, // Start off-screen (right side)
          end: -200, // Move to the left (off-screen)
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
        );
      });

      _controller.forward();
    });

    navigateBasedOnToken();
  }

  Future<void> navigateBasedOnToken() async {
    String? token = await SharedPrefs().getToken();

    print("-----$token");

    // Wait for 3 seconds before navigating
    Future.delayed(const Duration(seconds: 8), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      if (token != null && token.isNotEmpty) {
        // If the token exists, navigate to UserDashboard
        Navigator.pushReplacementNamed(context, Routes.dashboard);
      } else {
        // If no token, navigate to LoginScreen
        Navigator.pushReplacementNamed(context, Routes.login);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColor.splashBg, // Replace with your splash background color
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/logo.png", height: 200, width: 200),
                // Animated text
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _textLetters.map((letter) {
                    final index = _textLetters.indexOf(letter);
                    return AnimatedBuilder(
                      animation: _letterAnimations[index],
                      builder: (context, child) {
                        return Opacity(
                          opacity: _letterAnimations[index].value,
                          child: Text(
                            letter,
                            style: GoogleFonts.acme(
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              color: AppColor
                                  .theme, // Replace with your theme color
                              letterSpacing: 1,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          if (_animation != null)
            AnimatedBuilder(
              animation: _animation!,
              builder: (context, child) {
                return Positioned(
                  left: _animation!.value, // Moves from right to left
                  bottom: MediaQuery.of(context).size.height * 0.3,
                  child: Lottie.asset("assets/animation.json",
                      width: 200, height: 200),
                );
              },
            ),
        ],
      ),
    );
  }
}
