import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repostory/firebaseApi.dart';

class ResultDialog extends StatelessWidget {
  final String subject;
  final String mockTest;
  final double score;

  const ResultDialog({
    Key? key,
    required this.subject,
    required this.mockTest,
    required this.score,
  }) : super(key: key);

  void _navigateToScoreScreen(BuildContext context) async {
    await MyDb.calculateResultAndStore(
        subject: subject, mock: mockTest, score: score, context: context);
    Navigator.pushReplacementNamed(
      context,
      '/score',
      arguments: {
        'score': score,
        'subject': subject,
        'avg': 12.00,
        'topper': 25.00
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _navigateToScoreScreen(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      backgroundColor: Colors.white.withOpacity(0.9),
      title: Text(
        'Analyzing result...',
        style: GoogleFonts.acme(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }

  static void show(
      BuildContext context, String subject, String mockTest, double score) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultDialog(
        subject: subject,
        mockTest: mockTest,
        score: score,
      ),
    );
  }
}
