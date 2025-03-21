import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/userPart/repostory/googleAuthRepo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../core/contant/appColor.dart';
import '../core/routes.dart';
import '../domain/sharedPre.dart';
import '../widgets/internetchecker.dart';
import '../widgets/successDialog.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? profilePicUrl;

  CustomDrawer({
    required this.userName,
    required this.userEmail,
    this.profilePicUrl,
  });

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.red),
              SizedBox(width: 10),
              Text("Delete Account"),
            ],
          ),
          content: Text("Are you sure you want to delete your account?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog
              child: Text("No", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // Close the dialog first
                await deleteAccount(
                    context); // Call delete function after confirmation
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text("Yes", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  /// **Deletes the user account from Firestore and Firebase Auth**
  Future<void> deleteAccount(BuildContext context) async {
    try {
      // Retrieve the email from shared preferences
      String? email = await SharedPrefs().getEmail();
      if (email == null || email.isEmpty) {
        print("Email is empty, cannot delete account.");
        return;
      }

      // Reference the Firestore document using the email as the document ID
      DocumentReference userDoc =
          FirebaseFirestore.instance.collection("users").doc(email);

      // Check if the document exists
      DocumentSnapshot docSnapshot = await userDoc.get();
      if (!docSnapshot.exists) {
        print("User exit deleted from Firestore.");
        await userDoc.delete();
        AuthService.signOut(context);
        Navigator.pushReplacementNamed(context, Routes.login);
      } else if (!docSnapshot.exists) {
        print("User does not exist in Firestore.");
        if (context.mounted) {
          AuthService.signOut(context);
          Navigator.pushReplacementNamed(context, Routes.login);
        }
        return;
      }

      // Delete the Firestore document

      // Delete the user from Firebase Auth
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        try {
          AuthService.signOut(context);
          await user.delete();
          print("User deleted successfully from Firebase Auth.");
        } catch (e) {
          print("Error deleting user from Firebase Auth: $e");
          return;
        }
      }

      // Show success dialog and navigate to login
      if (context.mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          successDialog(
            context: context,
            onSuccess: () {
              if (context.mounted) {
                Navigator.pushReplacementNamed(context, Routes.login);
              }
            },
          );
        });
      }
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final internetService = context.watch<InternetService>();

    return Drawer(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topRight: Radius.circular(5),
        bottomRight: Radius.circular(5),
      )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Custom Drawer Header
          Container(
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage('assets/drawer.png'), // Your image path
                  fit: BoxFit.cover, // Ensures image covers the container
                  colorFilter: ColorFilter.mode(
                    Colors.white70, // Adjust color for fading effect
                    BlendMode.modulate, // Modifies image brightness
                  )),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColor.theme, // Start color
                  AppColor.theme.withOpacity(0.8), // Middle
                  AppColor.drawerTheme, // End color
                ],
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColor.bg,
                  backgroundImage: InternetService.isInternetAvailable &&
                          profilePicUrl != null &&
                          profilePicUrl!.isNotEmpty
                      ? NetworkImage(profilePicUrl!)
                      : null,
                  child: (!InternetService.isInternetAvailable ||
                          profilePicUrl == null ||
                          profilePicUrl!.isEmpty)
                      ? Icon(Icons.person, size: 40, color: AppColor.theme)
                      : null,
                ),
                SizedBox(height: 10),
                Text(
                  userName,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1),
                ),
                SizedBox(height: 5),
                Text(
                  userEmail,
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ],
            ),
          ),

          // Drawer Body
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.04),
              decoration: BoxDecoration(
                image: const DecorationImage(
                    image: AssetImage('assets/bricks.jpg'), // Your image path
                    fit: BoxFit.cover, // Ensures image covers the container
                    colorFilter: ColorFilter.mode(
                      Colors.white60, // Adjust color for fading effect
                      BlendMode.lighten, // Modifies image brightness
                    )),
                color: AppColor.drawerColor.withOpacity(0.8),
              ),
              child: Column(
                children: [
                  // Add other drawer items here if needed
                  Spacer(), // This will push the logout button to the bottom
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.privacyPolicy);
                      },
                      child: Text("Privacy Policy")),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthService.signOut(context);
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange, // Border color
                          width: 1.0, // Border width
                        ),
                        borderRadius:
                            BorderRadius.circular(8.0), // Rounded corners
                      ),
                      child: Text(
                        "Logout",
                        style: GoogleFonts.abrilFatface(
                          letterSpacing: 2,
                          fontSize: 16,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25), // Add some space at the bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
