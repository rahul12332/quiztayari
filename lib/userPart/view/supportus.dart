import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/scan_dailog_widget.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({Key? key}) : super(key: key);
  void showScannerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return ScannerDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Support Us'),
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back, // iOS-style back arrow
            color: Colors.white, // White color
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding around the screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity),
            // Slogan Section
            Text(
              'Buy Me a Coffee',
              style: GoogleFonts.acme(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Adjust color as needed
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20), // Space between slogan and QR code
            Text(
              'To support our mission of enhancing free education for everyone!',
              style: GoogleFonts.abhayaLibre(
                fontSize: 16,
                color: Colors.black54, // Adjust color as needed
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Image.asset("assets/coffee.png", height: 200),
            SizedBox(height: 20), // Space below the QR code
            GestureDetector(
              onTap: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => RazorpayPaymentScreen(),
                //   ),
                // );
              },
              child: Text(
                'Tab to Support!',
                style: GoogleFonts.abyssinicaSil(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
