import 'package:fast_quiz_tayari/userPart/core/contant/appColor.dart';
import 'package:fast_quiz_tayari/userPart/view/dasboard.dart';
import 'package:fast_quiz_tayari/userPart/view/subjectAnalytics.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repostory/scoreRepo.dart';
import '../widgets/userScoreData.dart';

class ScoreChart extends StatefulWidget {
  final double yourScore;
  final double avgScore;
  final double topperScore;
  final String subject;

  ScoreChart({
    required this.yourScore,
    required this.avgScore,
    required this.topperScore,
    required this.subject,
  });

  @override
  State<ScoreChart> createState() => _ScoreChartState();
}

class _ScoreChartState extends State<ScoreChart> {
  List<double> scores = [];

  @override
  void initState() {
    super.initState();
    // Fetch scores when the widget is initialized
    scoreList(subject: widget.subject);
  }

  Future<void> scoreList({required String subject}) async {
    List<double> fetchedScores = await ScoreRepo.getAllScoresForSubject(
      subject: subject,
    );

    // Update the scores list and refresh the UI
    setState(() {
      scores = fetchedScores;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scores Chart'),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ), // iOS-style back button
          onPressed: () {
            // Push replacement to UserDashBoard screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => UserDasboard()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.06),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300)),
              child: Column(
                children: [
                  ScoreRow(
                    firstPlaceText: "Your Score", // Text in the first column
                    secondPlaceText: widget.yourScore
                        .toString(), // Score value in the second column
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 0.8, // Set divider thickness
                    indent: 0, // No indent
                    endIndent: 0, // No end indent
                  ),
                  ScoreRow(
                    firstPlaceText: "Attempt", // Text in the first column
                    secondPlaceText: "25", // Score value in the second column
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 0.8, // Set divider thickness
                    indent: 0, // No indent
                    endIndent: 0, // No end indent
                  ),
                  ScoreRow(
                    firstPlaceText: "Nor Attempt", // Text in the first column
                    secondPlaceText: "5", // Score value in the second column
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 0.8, // Set divider thickness
                    indent: 0, // No indent
                    endIndent: 0, // No end indent
                  ),
                  ScoreRow(
                    firstPlaceText: "Wrong", // Text in the first column
                    secondPlaceText: "10", // Score value in the second column
                  ),
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 0.8, // Set divider thickness
                    indent: 0, // No indent
                    endIndent: 0, // No end indent
                  ),
                  ScoreRow(
                    firstPlaceText: "Correct", // Text in the first column
                    secondPlaceText: "20", // Score value in the second column
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Colors.grey.shade200,
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: BarChart(
                  BarChartData(
                    gridData: FlGridData(
                      show: false, // Remove horizontal dotted lines
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false, // Disable Y-axis numbers
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, titleMeta) {
                            switch (value.toInt()) {
                              case 0:
                                return Text(
                                  'Your ',
                                  style: GoogleFonts.acme(fontSize: 15),
                                );
                              case 1:
                                return Text(
                                  'Avg ',
                                  style: GoogleFonts.acme(fontSize: 15),
                                );
                              case 2:
                                return Text(
                                  'Topper ',
                                  style: GoogleFonts.acme(fontSize: 15),
                                );
                              default:
                                return Text('');
                            }
                          },
                        ),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: false, // Remove top numbers (0, 1, 2)
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: false,
                    ), // Remove the border line
                    barGroups: _createBarGroups(),
                    barTouchData: BarTouchData(
                      enabled: false,
                    ), // Disable touch effects
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            scores.length <= 2
                ? SizedBox()
                : GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomAxisChart(
                            subject: widget.subject,
                            numbers: scores,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        "Subject Report",
                        style: GoogleFonts.acme(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  // Create the Bar Groups for the chart
  List<BarChartGroupData> _createBarGroups() {
    return [
      BarChartGroupData(
        x: 0, // Position of the first bar (Your Score)
        barRods: [
          BarChartRodData(
            toY: widget.yourScore.toDouble(),
            color: _getBarColor(widget.yourScore),
            width: 50,
            borderRadius: BorderRadius.zero, // Rectangular bar
          ),
        ],
      ),
      BarChartGroupData(
        x: 1, // Position of the second bar (Avg Score)
        barRods: [
          BarChartRodData(
            toY: widget.avgScore.toDouble(),
            color: _getBarColor(widget.avgScore),
            width: 50,
            borderRadius: BorderRadius.zero, // Rectangular bar
          ),
        ],
      ),
      BarChartGroupData(
        x: 2, // Position of the third bar (Topper Score)
        barRods: [
          BarChartRodData(
            toY: widget.topperScore.toDouble(),
            color: _getBarColor(widget.topperScore),
            width: 50,
            borderRadius: BorderRadius.zero, // Rectangular bar
          ),
        ],
      ),
    ];
  }

  // Return the color based on the score value
  Color _getBarColor(double score) {
    if (score < 10) {
      return AppColor.redColor; // Red color for score < 10
    } else if (score >= 10 && score <= 15) {
      return AppColor.yellowColor; // Orange color for score between 10 and 15
    } else {
      return AppColor.greenColor; // Green color for score > 15
    }
  }
}
