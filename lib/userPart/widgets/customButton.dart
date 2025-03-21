import 'package:fast_quiz_tayari/userPart/core/contant/appColor.dart';
import 'package:flutter/material.dart';

class Custombutton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  Custombutton({required this.label, required this.onPressed});
  void onButtonPress() {}

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9, // 70% width of the screen
      height: 50, // You can adjust the height as per your design
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.summitColor,
          elevation: 0, // No elevation
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // Rounded corners
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16, // Adjust the text size
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
      ),
    );
  }
}
