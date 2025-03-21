import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Define the custom widget with constructor parameters
class ScoreRow extends StatelessWidget {
  final String firstPlaceText; // Text for the first column (e.g., "Your Score")
  final String secondPlaceText; // Text for the second column (score value)

  // Constructor to pass values to the widget
  const ScoreRow({
    Key? key,
    required this.firstPlaceText,
    required this.secondPlaceText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceEvenly, // Distribute space evenly
      children: [
        Expanded(
          child: Center(
            child: Text(
              firstPlaceText,
              style: GoogleFonts.afacad(fontSize: 15, color: Colors.black54),
            ),
          ),
        ),
        Container(
          height: 30, // Adjust to match the height of the text
          child: VerticalDivider(
            width: 1, // Thickness of the divider
            color: Colors.grey.shade300,
          ),
        ),
        Expanded(
          child: Center(
            child: Text(
              secondPlaceText,
              style: GoogleFonts.afacad(fontSize: 15, color: Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
