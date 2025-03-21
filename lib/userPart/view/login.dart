import 'package:fast_quiz_tayari/userPart/repostory/googleAuthRepo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/contant/appColor.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background image for the entire scaffold
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.22),
            Text(
              'Fast Quiz',
              style: GoogleFonts.acme(
                fontSize: 40,
                fontWeight: FontWeight.w600,
                color: AppColor.splash_theme,
                letterSpacing: 1,
              ),
            ),

            // "tayari" Text
            Text(
              'Tayari',
              style: GoogleFonts.abhayaLibre(
                fontSize: 22,
                letterSpacing: 1,
                fontWeight: FontWeight.w300,
                color: Colors.black.withOpacity(0.8),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                AuthService.signInWithGoogle(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.theme, // Border color
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(5.0), // Rounded corners
                  color: Colors.white.withOpacity(
                    0.9,
                  ), // Semi-transparent background
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/google.png', // Replace with your Google icon path
                      height: 24,
                      width: 24,
                      color: Colors.orangeAccent,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Login with Google",
                      style: GoogleFonts.actor(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: AppColor.theme,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
              child: Image.asset("assets/login.png"),
            ),
          ],
        ),
      ),
    );
  }
}
