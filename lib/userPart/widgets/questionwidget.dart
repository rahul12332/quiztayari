import 'package:flutter/material.dart';

import '../core/contant/appColor.dart';

class SmokeyQuestionWidget extends StatelessWidget {
  final int serialNumber;
  final String question;

  SmokeyQuestionWidget({required this.serialNumber, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [
            AppColor.theme.withOpacity(0.1), // Main color
            AppColor.theme.withOpacity(0.2), // Slightly transparent variation
            AppColor.theme.withOpacity(0.1)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Optional rounded corners
        boxShadow: [
          BoxShadow(
            color: AppColor.questionColor
                .withOpacity(0.1), // Shadow color similar to the gradient
            spreadRadius: 2, // Spread effect
            blurRadius: 2, // Smooth blur
            offset: const Offset(1, 2), // Shadow position
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Aligns text properly if multiline
        children: [
          // Serial number (e.g., "1.")
          Text(
            '$serialNumber. ',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          // The question text
          Expanded(
            child: Text(
              question,
              style: TextStyle(
                wordSpacing: 2,
                fontWeight: FontWeight.w100,
                fontSize: 15,
                color: Colors.black.withOpacity(0.6),
              ),
              maxLines: null, // Allows unlimited lines
              softWrap: true, // Enables text wrapping
            ),
          ),
        ],
      ),
    );
  }
}
