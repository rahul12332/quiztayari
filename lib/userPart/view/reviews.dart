import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/userPart/core/contant/appColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../domain/sharedPre.dart';
import '../widgets/questionwidget.dart';

class Reviews extends StatefulWidget {
  final String subject;
  final String mock;

  const Reviews({super.key, required this.subject, required this.mock});

  @override
  State<Reviews> createState() => _MocktestState();
}

class _MocktestState extends State<Reviews> {
  List<Map<String, dynamic>> questions = [];
  int currentQuestionIndex = 0;
  Map<int, String?> selectedOptions =
      {}; // Track selected options for each question

  @override
  void initState() {
    super.initState();
    _fetchQuestions(widget.subject, widget.mock);
  }

  @override

  // Fetch the questions based on subject and mock
  Future<void> _fetchQuestions(String subject, String mock) async {
    String? email = await SharedPrefs().getEmail();
    print("---$email");

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(email) // Use logged-in user email
          .collection(subject) // Example: 'maths'
          .doc(mock) // Example: 'mock 1'
          .collection('questions') // Fetch from the subcollection
          .get();

      List<Map<String, dynamic>> fetchedQuestions =
          []; // List to store questions

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

        if (fetchedQuestions.isNotEmpty) {
          print("📚 Loaded ${fetchedQuestions.length} questions successfully!");
        } else {
          print("⚠️ No valid questions found in Firestore.");
        }
      } else {
        print("❌ No question documents found in Firestore.");
      }

      // ✅ Assign to state variable if using StatefulWidget
      setState(() {
        questions = fetchedQuestions;
      });
    } catch (e) {
      print("❌ Error fetching questions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text("Mock Test - ${widget.subject}")),
        body: Center(
            child: CircularProgressIndicator(
          color: Colors.orangeAccent.shade200,
        )),
      );
    }

    final currentQuestion = questions[currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Mock Test - ${widget.subject}"),
        automaticallyImplyLeading: false, // Removes the default back button
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display current question
            SmokeyQuestionWidget(
              question: currentQuestion["question"],
              serialNumber: currentQuestionIndex + 1,
            ),
            const SizedBox(height: 20),
            if (currentQuestion['yourOption'] == null)
              // ✅ Not Attempted Case
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.timer, color: Colors.green),
                  SizedBox(width: 10),
                  Text(
                    "Not Attempted",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

            // Display options (Radio Buttons)
// Display options with color coding
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5),
              height: MediaQuery.of(context).size.height * 0.4,
              child: ListView.builder(
                itemCount: currentQuestion['options'].length,
                itemBuilder: (context, index) {
                  String optionText = currentQuestion['options'][index];
                  String correctAnswer = currentQuestion['correctAnswer'];
                  String? userSelectedOption = currentQuestion['yourOption'];

                  Color textColor = Colors.black; // Default color
                  if (userSelectedOption != null) {
                    if (optionText == correctAnswer) {
                      textColor = Colors.green; // ✅ Correct answer in green
                    } else if (optionText == userSelectedOption) {
                      textColor = Colors.red; // ❌ User's wrong answer in red
                    }
                  }

                  return Container(
                    margin: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(5),
                      border:
                          Border.all(width: 0.5, color: Colors.grey.shade400),
                    ),
                    child: RadioListTile<String>(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      activeColor: Colors.green,
                      value: optionText,
                      groupValue: userSelectedOption, // Locked selection
                      title: Text(
                        optionText,
                        style: GoogleFonts.acme(
                          color: textColor, // Set color based on correctness
                          letterSpacing: 1,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      onChanged:
                          null, // ❌ Locked - Users cannot change selection
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 40,
            ),
            // Show Previous Button and Next Button
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          if (currentQuestionIndex > 0)
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    currentQuestionIndex--;
                                  });
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: AppColor.redColor,
                                ),
                              ),
                            ),
                          Spacer(),
                          Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 1),
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (currentQuestionIndex <
                                    questions.length - 1) {
                                  setState(() {
                                    currentQuestionIndex++; // Move to next question
                                  });
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text("This is the last question!")),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.arrow_forward,
                                color: AppColor.theme,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // Show Submit Button if it's the last question
                  ],
                ),
              ),
            ),
            // Below the Next button
            Container(
              margin: EdgeInsets.all(12),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Explanation:",
                    style: GoogleFonts.acme(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    currentQuestion['explanation'] ??
                        "No explanation available.",
                    style: GoogleFonts.acme(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
