import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScannerDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ), // Set border radius to 5
      ),
      contentPadding: EdgeInsets.all(16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 200, // Adjust the height for the image
            width: double.infinity, // Make it wide
            child: Image.asset(
              'assets/googleScan.jpg', // Replace with your image asset path
              fit: BoxFit.cover, // Adjust the image to fill the container
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text(
              "Close",
              style: GoogleFonts.acme(
                color: Colors.white,
                letterSpacing: 2,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4), // Rounded corners
              ),
              backgroundColor: Colors.red.withOpacity(
                0.6,
              ), // Set color for the Close button
            ),
          ),
        ],
      ),
    );
  }
}
