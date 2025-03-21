import 'package:cloud_firestore/cloud_firestore.dart';

import '../domain/sharedPre.dart';

class ScoreRepo {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Static method to save score in Firestore
  static Future<void> saveScore({
    required String subject,
    required String mockTest,
    required double score,
  }) async {
    // Retrieve email from SharedPrefs
    String? email = await SharedPrefs().getEmail();

    if (email == null) {
      print('Error: No email found in SharedPreferences');
      return; // If email is not found, do not proceed
    }

    try {
      // Reference to the user's document using their email
      DocumentReference userRef = _firestore.collection('users').doc(email);

      // Check if the user document exists
      DocumentSnapshot userSnapshot = await userRef.get();

      if (!userSnapshot.exists) {
        // User document does not exist, create a new user document
        await userRef.set({
          'email': email, // Save the email field for reference
        });
        print('New user document created!');
      }

      // Reference to the subject subcollection (e.g., 'English')
      CollectionReference subjectRef = userRef.collection(subject);

      // Reference to the specific mock test document (e.g., 'mock1')
      DocumentReference mockTestRef = subjectRef.doc(mockTest);

      // Save the score to the mock test document
      await mockTestRef.set({'score': score}, SetOptions(merge: true));

      print('Score saved successfully!');
    } catch (e) {
      print('Error saving score: $e');
    }
  }

  static Future<double?> getScore({
    required String subject,
    required String mockTest,
  }) async {
    // Retrieve email from SharedPrefs
    String? email = await SharedPrefs().getEmail();

    if (email == null) {
      print('Error: No email found in SharedPreferences');
      return null; // Return null if email is not found
    }

    try {
      // Reference to the user's document using their email
      DocumentReference userRef = _firestore.collection('users').doc(email);

      // Reference to the subject subcollection (e.g., 'English')
      CollectionReference subjectRef = userRef.collection(subject);

      // Reference to the specific mock test document (e.g., 'mock1')
      DocumentReference mockTestRef = subjectRef.doc(mockTest);

      // Fetch the mock test document
      DocumentSnapshot mockTestSnapshot = await mockTestRef.get();

      if (mockTestSnapshot.exists) {
        // Get the score field from the document and return it
        var score = mockTestSnapshot['score'];
        return score != null ? score.toDouble() : null;
      } else {
        print('Mock test document does not exist!');
        return null; // Return null if the mock test document does not exist
      }
    } catch (e) {
      print('Error retrieving score: $e');
      return null; // Return null in case of an error
    }
  }

  // Static method to get all mock test scores for a subject
  static Future<List<double>> getAllScoresForSubject({
    required String subject,
  }) async {
    // Retrieve email from SharedPrefs
    String? email = await SharedPrefs().getEmail();

    if (email == null) {
      print('Error: No email found in SharedPreferences');
      return []; // Return an empty list if email is not found
    }

    try {
      // Reference to the user's document using their email
      DocumentReference userRef = _firestore.collection('users').doc(email);

      // Reference to the subject subcollection (e.g., 'maths')
      CollectionReference subjectRef = userRef.collection(subject);

      // Fetch all mock test documents under the subject subcollection
      QuerySnapshot mockTestsSnapshot = await subjectRef.get();

      if (mockTestsSnapshot.docs.isEmpty) {
        print('No mock test documents found!');
        return []; // Return an empty list if no mock tests are found
      }

      // List to store all scores
      List<double> scoresList = [];

      // Loop through each mock test document
      for (var doc in mockTestsSnapshot.docs) {
        var score = doc['score'];
        if (score != null) {
          // Add only the score to the list
          scoresList.add(score.toDouble());
        }
      }

      return scoresList;
    } catch (e) {
      print('Error retrieving scores for subject: $e');
      return []; // Return an empty list in case of an error
    }
  }
}
