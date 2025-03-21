import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/contant/appColor.dart';

class StatewiseWidget extends StatelessWidget {
  final String subject; // Single subject name

  StatewiseWidget({Key? key, required this.subject}) : super(key: key);

  // Function to dynamically assign icons based on subject names
  IconData _getIconForSubject(String subject) {
    // List of keywords for matching
    const subjectKeywords = {
      'english': Icons.language,
      'maths': Icons.calculate,
      'quant': Icons.bar_chart,
      'computer': Icons.computer,
      'science': Icons.science,
      'history': Icons.history,
      'geography': Icons.map,
      'literature': Icons.book,
      'biology': Icons.pest_control,
      'physics': Icons.flare,
      'art': Icons.palette,
      'economics': Icons.attach_money,
      'reasoning': Icons
          .lightbulb, // Reasoning - Lightbulb icon to represent problem-solving or thinking
    };

    // Convert the subject to lowercase for comparison
    String lowerSubject = subject.toLowerCase();

    // Check if the subject matches any keyword in the dictionary
    for (var keyword in subjectKeywords.keys) {
      if (lowerSubject.contains(keyword)) {
        return subjectKeywords[keyword]!; // Return the matched icon
      }
    }

    return Icons.help_outline; // Default icon for unknown subjects
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.8), width: 0.3),
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [
            AppColor.drawerTheme.withOpacity(0.2), // Main color
            AppColor.drawerTheme
                .withOpacity(0.2), // Slightly transparent variation
            AppColor.drawerTheme.withOpacity(0.3)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        // Optional rounded corners
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Subject name displayed as text
          Text(
            subject,
            style: GoogleFonts.alike(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey, // Text color from theme
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8), // Spacing between text and icon
          // Icon dynamically generated based on subject name
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(90)),
            child: Icon(
              _getIconForSubject(subject),
              color: AppColor.iconColor, // Icon color from theme
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}

//rzp_test_cg6qYa80j4CgD1
//BzxlgC5J1dpF8ZbxReHQT5xX
