import 'package:flutter/material.dart';

class ProgressDialog {
  static void show(BuildContext context, bool isLoading) {
    if (isLoading) {
      // Show the dialog
      showDialog(
        context: context,
        barrierDismissible: false, // Prevent closing by tapping outside
        builder: (BuildContext context) {
          return Center(
            child: Container(
              color: Colors.transparent, // Transparent background
              child: CircularProgressIndicator(
                color: Colors.orange, // Orange progress indicator
              ),
            ),
          );
        },
      );
    } else {
      // Close the dialog
      Navigator.of(context, rootNavigator: true).pop();
    }
  }
}
