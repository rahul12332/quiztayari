import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ScoreCountScreen extends StatefulWidget {
  @override
  _ScoreCountScreenState createState() => _ScoreCountScreenState();
}

class _ScoreCountScreenState extends State<ScoreCountScreen> {
  final String email =
      "camit97chandra@gmail.com"; // Replace with dynamic email if needed
  int totalScore = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTotalScore();
  }

  Future<void> fetchTotalScore() async {
    try {
      int count = await getTotalScore(email);
      setState(() {
        totalScore = count;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching total score: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<int> getTotalScore(String email) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    DocumentReference userDoc = firestore.collection("users").doc(email);

    int totalScore = 0;

    // Predefined list of subject names
    List<String> subjectNames = [
      'Computer',
      'economic',
      'maths'
    ]; // Add all subjects here

    try {
      print("Fetching total scores...");

      for (String subjectName in subjectNames) {
        print("Processing subject: $subjectName");

        // Get all mocks inside each subject
        QuerySnapshot mockSnapshot =
            await userDoc.collection(subjectName).get();

        for (var mockDoc in mockSnapshot.docs) {
          // Fetch the score field from each mock
          int score = mockDoc.get("score") ?? 0;
          totalScore += score;
          print("Current total score: $totalScore");
        }
      }

      return totalScore;
    } catch (e) {
      print("Error fetching total score: $e");
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Total Score")),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  "Total Score: $totalScore",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}
