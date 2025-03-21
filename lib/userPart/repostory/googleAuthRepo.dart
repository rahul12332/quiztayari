import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../core/contant/appColor.dart';
import '../core/helper.dart';
import '../core/networkError.dart';
import '../core/routes.dart';
import '../domain/sharedPre.dart';
import '../view/login.dart';
import '../widgets/customCircularProgressIndicatior.dart'; // Replace with your login screen

class AuthService {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static Future<User?> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      final User? user = userCredential.user;

      if (user != null) {
        final sharedPrefs = SharedPrefs();
        await sharedPrefs.saveToken(googleAuth.accessToken ?? "");
        await sharedPrefs.saveEmail(user.email ?? "");
        await sharedPrefs.saveName(user.displayName ?? "");
        await sharedPrefs.saveImage(user.photoURL ?? "");

        String? savedToken = await sharedPrefs.getToken();

        print("Token saved: \$savedToken");
        print("Email saved: \${user.email}");

        Navigator.pushReplacementNamed(context, Routes.dashboard);

        SnackBarHelper.showSnackBar(context, "Login successfully!",
            backgroundColor: AppColor.theme);
      }
      return user;
    } catch (e) {
      FirebaseError error = FirebaseError.withError(error: e);
      SnackBarHelper.showSnackBar(
          context, "Error:  ${error.getErrorMessage()}");
      return null;
    }
  }

  // Method to sign out and clear preferences
  static Future<void> signOut(BuildContext context) async {
    try {
      // Show the progress dialog
      ProgressDialog.show(context, true);

      // Sign out from Google
      await _googleSignIn.signOut();

      // Clear SharedPreferences
      SharedPrefs prefs = SharedPrefs();
      await prefs.clearUserData();

      // Close the progress dialog
      ProgressDialog.show(context, false);

      // Navigate to Login Screen directly
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(), // Replace with your login screen
        ),
      );
    } catch (e) {
      // Close the progress dialog in case of error
      ProgressDialog.show(context, false);
      FirebaseError error = FirebaseError.withError(error: e);

      SnackBarHelper.showSnackBar(
          context, "Error:  ${error.getErrorMessage()}");
    }
  }
}
