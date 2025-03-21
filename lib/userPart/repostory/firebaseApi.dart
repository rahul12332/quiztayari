import 'dart:isolate';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/userPart/domain/sharedPre.dart';
import 'package:flutter/cupertino.dart';

import '../core/helper.dart';
import '../core/networkError.dart';

class MyDb {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> fetchAndUpdateQuestion({
    required String subject,
    required String mock,
    required int questionIndex,
    required String selectedOption,
  }) async {
    String? email = await SharedPrefs().getEmail();
    print("--- Logged-in User: $email");

    try {
      // Reference to the "questions" document inside the "questions" subcollection
      DocumentReference questionsDocRef = FirebaseFirestore.instance
          .collection('users')
          .doc(email)
          .collection(subject)
          .doc(mock)
          .collection('questions')
          .doc('questions'); // This document contains the questions array

      // Fetch the document
      DocumentSnapshot docSnap = await questionsDocRef.get();

      if (!docSnap.exists) {
        print("❌ Questions document not found!");
        return;
      }

      // Extract questions array
      Map<String, dynamic>? data = docSnap.data() as Map<String, dynamic>?;
      if (data == null || !data.containsKey('questions')) {
        print("❌ No questions found!");
        return;
      }

      List<dynamic> questions = data['questions']; // Retrieve the array

      if (questionIndex < 0 || questionIndex >= questions.length) {
        print("⚠️ Invalid index: $questionIndex. Out of range.");
        return;
      }

      // Fetch specific question
      Map<String, dynamic> questionData = questions[questionIndex];

      print("📌 Question at index $questionIndex: ${questionData['question']}");

      // Update `yourOption`
      questions[questionIndex]['yourOption'] = selectedOption;

      // Update the entire array in Firestore
      await questionsDocRef.update({'questions': questions});

      print("✅ yourOption updated successfully: $selectedOption");
    } catch (e) {
      print("❌ Error fetching/updating yourOption: $e");

      if (e is FirebaseException) {
        print("Firebase error code: ${e.code}");
        print("Firebase error message: ${e.message}");
      }
    }
  }

  static Future<List<Map<String, dynamic>>> fetchQuestions(
      {required String subject,
      required String mock,
      required BuildContext context}) async {
    String? email = await SharedPrefs().getEmail();
    print("---$email");

    List<Map<String, dynamic>> fetchedQuestions = []; // List to store questions

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email) // Use logged-in user email
          .collection(subject) // Example: 'maths'
          .doc(mock) // Example: 'mock 1'
          .collection('questions') // Fetch from the subcollection
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        print("✅ Found ${querySnapshot.docs.length} question documents.");
        for (var doc in querySnapshot.docs) {
          if (doc.data() is Map<String, dynamic>) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

            if (data.containsKey('questions') && data['questions'] is List) {
              List<dynamic> questionsList = data['questions']; // Extract list
              for (var question in questionsList) {
                if (question is Map<String, dynamic>) {
                  fetchedQuestions.add(question);
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print("❌ Error fetching questions: $e");
      FirebaseError error = FirebaseError.withError(error: e);

      SnackBarHelper.showSnackBar(
          context, "Error:  ${error.getErrorMessage()}");
    }

    return fetchedQuestions; // Return the fetched list
  }

  static Future<Map<String, double>> calculateTopperAndAvg({
    required String subject,
    required String mock,
  }) async {
    try {
      CollectionReference usersCollection = _firestore.collection('users');

      double totalScore = 0;
      int userCount = 0;
      double highestScore = 0;

      // 🔹 Fetch all users in Firestore
      QuerySnapshot usersSnapshot = await usersCollection.get();
      print("📢 Found ${usersSnapshot.docs.length} users in Firestore.");

      if (usersSnapshot.docs.isEmpty) {
        print("❌ No users found in Firestore.");
        return {'avg': 0.0, 'topper': 0.0};
      }

      // 🔹 Loop through each user
      for (QueryDocumentSnapshot userDoc in usersSnapshot.docs) {
        String userEmail = userDoc.id;
        print("🔎 Checking user: $userEmail");

        // Reference to the user's mock document inside the subject collection
        DocumentSnapshot mockDoc = await _firestore
            .collection('users')
            .doc(userEmail)
            .collection(subject)
            .doc(mock)
            .get();

        if (!mockDoc.exists) {
          print("⚠️ No mock test found for $userEmail at $subject → $mock");
          continue;
        }

        Map<String, dynamic>? mockData =
            mockDoc.data() as Map<String, dynamic>?;

        if (mockData == null || !mockData.containsKey('score')) {
          print("⚠️ No score found for $userEmail at $subject → $mock");
          continue;
        }

        // Extract score and convert to double
        double userScore = (mockData['score'] as num).toDouble();
        print("✅ $userEmail → Score: $userScore");

        // Add score to total
        totalScore += userScore;
        userCount++;

        // Update highest score
        if (userScore > highestScore) {
          highestScore = userScore;
        }
      }

      // 🔹 Calculate average score
      double avg = (userCount > 0) ? (totalScore / userCount) : 0.0;
      avg = double.parse(avg.toStringAsFixed(2)); // Round to 2 decimal places

      print("🎯 Final Scores - Avg: $avg, Topper: $highestScore");

      return {
        'avg': avg,
        'topper': highestScore,
      };
    } catch (e) {
      print("❌ Error calculating topper and avg: $e");
      return {'avg': 0.0, 'topper': 0.0};
    }
  }

  static Future<void> calculateResultAndStore(
      {required String subject,
      required String mock,
      required double score,
      required BuildContext context}) async {
    try {
      String? email = await SharedPrefs().getEmail();
      if (email == null) {
        print("❌ Error: User email is null");
        return;
      }

      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // ✅ Fetch the "questions" document inside "questions" subcollection
      DocumentSnapshot questionDoc = await firestore
          .collection('users')
          .doc(email)
          .collection(subject)
          .doc(mock)
          .collection('questions')
          .doc('questions') // The document named "questions"
          .get();

      if (!questionDoc.exists || questionDoc.data() == null) {
        print("❌ No questions document found.");
        return;
      }

      Map<String, dynamic> data = questionDoc.data() as Map<String, dynamic>;
      List<dynamic> questionsList = data['questions'] ?? [];

      int attempted = 0;
      int notAttempted = 0;
      int correct = 0;
      int incorrect = 0;

      for (int i = 0; i < questionsList.length; i++) {
        Map<String, dynamic> question = questionsList[i];
        String userOption = (question['yourOption'] ?? "null")
            .toString(); // ✅ Ensure userOption is a string
        String correctOption = (question['correctOption'] ?? "")
            .toString(); // ✅ Ensure correctOption is a string

        if (userOption == "null" || userOption.isEmpty) {
          notAttempted++;
          // ✅ Explicitly set "yourOption": null in Firestore if missing
          questionsList[i]['yourOption'] = null;
        } else {
          attempted++;
          if (userOption == correctOption) {
            correct++;
          } else {
            incorrect++;
          }
        }
      }

      // ✅ Update Firestore to ensure all questions have "yourOption"
      await questionDoc.reference.update({'questions': questionsList});

      print(
          "📊 Attempted: $attempted, Not Attempted: $notAttempted, Correct: $correct, Incorrect: $incorrect");

      // ✅ Calculate accuracy
      double accuracy = attempted > 0 ? (correct / attempted) * 100 : 0;

      // ✅ Fetch avg & topper from `calculateTopperAndAvg()`
      Map<String, dynamic> result =
          await calculateTopperAndAvg(subject: subject, mock: mock);
      print("toopr${result['avg']}");
      double avg = result['avg'] ?? 0;
      double topper = result['topper'] ?? 0;

      // ✅ Update Firestore in the mock document
      DocumentReference mockRef = firestore
          .collection('users')
          .doc(email)
          .collection(subject)
          .doc(mock);

      await mockRef.set({
        'attempted': attempted,
        'notAttempted': notAttempted,
        'correct': correct,
        'incorrect': incorrect,
        'accuracy': accuracy.toStringAsFixed(2),
        'avg': avg,
        'topper': topper,
        'score': score,
      }, SetOptions(merge: true));

      print("✅ Results stored successfully for $email in mock $mock.");
    } catch (e) {
      FirebaseError error = FirebaseError.withError(error: e);

      SnackBarHelper.showSnackBar(
          context, "Error:  ${error.getErrorMessage()}");
    }
  }

  static void fetchSeriesIsolate(SendPort sendPort) async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('series').get();
    List<Map<String, dynamic>> data =
        snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
    sendPort.send(data);
  }
}
