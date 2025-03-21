import 'package:flutter/material.dart';

import '../core/contant/appColor.dart';
import '../core/routes.dart';

class CustomMockContainer extends StatelessWidget {
  final String mock;
  final String subject;
  final int index;
  final double? score;
  final bool lockIcon; // Determines whether to show the lock icon

  CustomMockContainer({
    required this.mock,
    required this.subject,
    required this.index,
    required this.score,
    required this.lockIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: AppColor.theme.withOpacity(0.3), width: 0.5),
        gradient: LinearGradient(
          colors: [
            AppColor.subMocListColor.withOpacity(0.3), // Main color
            AppColor.subMocListColor
                .withOpacity(0.1), // Slightly transparent variation
            AppColor.subMocListColor.withOpacity(0.08)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Index Number
          CircleAvatar(
            backgroundColor: Colors.grey.shade100,
            child: Text(index.toString(),
                style: TextStyle(fontWeight: FontWeight.w500)),
          ),
          // Mock Name
          Text(
            mock,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          // Icon Handling: Lock, Check, or Forward Arrow
          if (lockIcon)
            Icon(Icons.lock, color: Colors.red) // 🔒 Red Lock Icon (if locked)
          else if (score != null && score! > 0)
            Container(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.review,
                        arguments: {'subject': subject, 'mock': mock},
                      );
                    },
                    color: Colors.green,
                    icon: Icon(
                      Icons.history,
                      color: Colors.orangeAccent.shade200,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        Routes.score,
                        arguments: {
                          'score': score!,
                          'subject': subject,
                          'avg': 20.0,
                          'topper': 25.0,
                        },
                      );
                    },
                    color: Colors.green,
                    icon: Icon(Icons.check),
                  ),
                ],
              ),
            ) // ✅ Green Check Icon (if score > 0)
          else
            Icon(Icons.arrow_forward_ios,
                color: Colors.grey.shade200), // ➡️ Grey Arrow (if score == 0.0)
        ],
      ),
    );
  }
}
