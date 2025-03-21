import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/userPart/domain/sharedPre.dart';
import 'package:fast_quiz_tayari/userPart/widgets/internetchecker.dart';
import 'package:flutter/material.dart';

import '../core/routes.dart';
import '../widgets/customCircularProgressIndicatior.dart';

class HandleNavi {
  static Future<void> navigateToMockTestOrPayment(
      {required BuildContext context,
      required String mockTestName,
      required bool isPaid,
      required String userEmail,
      required String subjectName,
      required int subjectIndex,
      required int mockIndex}) async {
    String? token = await SharedPrefs().getToken();
    print("----we print token $token");
    // If the mock test is free, navigate directly to the mock test screen
    if (!InternetService.isInternetAvailable) {
      Navigator.pushNamed(
        context,
        Routes.mockTest,
        arguments: {
          'subject': subjectName,
          'mock': mockTestName,
          'subjectIndex': subjectIndex,
          "mockIndex": mockIndex
        },
      );
    } else {
      if (!isPaid) {
        print("✅ Redirecting to Mocktest Screen (Free Mock)");
        await _storeQuestionsWithLoader(
            context, userEmail, subjectName, mockTestName);
        Navigator.pushNamed(
          context,
          Routes.mockTest,
          arguments: {
            'subject': subjectName,
            'mock': mockTestName,
            'subjectIndex': subjectIndex,
            "mockIndex": mockIndex
          },
        );
        return;
      }

      if (userEmail.isEmpty) {
        print("❌ User email is null or empty");
        return;
      }

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail)
          .get();

      Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;

      bool hasPaid = userData != null &&
          userData.containsKey('paymentStatus') &&
          userData['paymentStatus'] == true;

      print("🟢 User Payment Status: $hasPaid");

      if (hasPaid) {
        // If the user has paid, navigate to the mock test screen
        print("✅ Redirecting to Mocktest Screen (Paid Mock)");
        await _storeQuestionsWithLoader(
            context, userEmail, subjectName, mockTestName);
        Navigator.pushNamed(
          context,
          Routes.mockTest,
          arguments: {
            'subject': subjectName,
            'mock': mockTestName,
            'subjectIndex': subjectIndex,
            "mockIndex": mockIndex
          },
        );
      } else {
        // If the user has not paid or the field is missing, redirect to the payment screen
        print("➡️ Redirecting to Payment Screen");
        Navigator.pushNamed(context, Routes.razorPay);
      }
    }
  }

  // Helper function to fetch and store questions with a loading indicator
  static Future<void> _storeQuestionsWithLoader(BuildContext context,
      String userEmail, String subjectName, String mockTestName) async {
    ProgressDialog.show(context, true); // Show loader
    try {
      await _storeQuestions(userEmail, subjectName, mockTestName);
    } finally {
      ProgressDialog.show(context, false); // Dismiss loader
    }
  }

  // Helper function to fetch and store questions
  static Future<void> _storeQuestions(
      String userEmail, String subjectName, String mockTestName) async {
    String? token = await SharedPrefs().getToken();
    print("token --$token");

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      var snapshot = await firestore
          .collection('series/$subjectName/mocks/$mockTestName/questions')
          .get();

      List<Map<String, dynamic>> questionsToStore = [];
      for (var doc in snapshot.docs) {
        questionsToStore.add({
          'question': doc['question'],
          'options': List<String>.from(doc['options']),
          'correctAnswer': doc['correctAnswer'],
          'explanation': doc['explanation']
        });
      }

      await firestore
          .collection('users/$userEmail/$subjectName/$mockTestName/questions')
          .doc('questions')
          .set({'questions': questionsToStore}, SetOptions(merge: false));

      print("✅ Questions stored successfully.");
    } catch (e) {
      print("❌ Error storing questions: $e");
    }
  }
}
