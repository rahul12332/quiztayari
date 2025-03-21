import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SnackBarHelper {
  static void showSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Acme',
          ),
        ),
        backgroundColor: backgroundColor,
        duration: Duration(seconds: 3),
      ),
    );
  }
}

void showCustomToast(BuildContext context,
    {required String message, required Color color}) {
  FToast fToast = FToast();
  fToast.init(context); // Use the correct BuildContext

  Widget toast = Container(
    width: MediaQuery.of(context).size.width * 0.95, // 80% screen width
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    decoration: BoxDecoration(
      color: color,
      border: Border.all(width: 1, color: Colors.grey.shade200),
      borderRadius:
          BorderRadius.circular(8.0), // Rectangular shape with soft edges
    ),
    child: Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
    ),
  );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 3),
  );
}
