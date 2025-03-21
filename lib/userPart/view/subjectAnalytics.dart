import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomAxisChart extends StatelessWidget {
  final String subject; // Subject name
  final List<double> numbers; // List of numbers to display on the chart

  CustomAxisChart({required this.subject, required this.numbers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Subject Analytic Report")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the subject name with the Google font "Acme"
            Center(
              child: Text(
                subject,
                style: GoogleFonts.acme(
                  color: Colors.orange,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Display the chart
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: false, // Hide grid lines
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40, // Reserve space for titles
                        interval: 5, // Y-axis labels every 5 units
                        getTitlesWidget: (value, meta) {
                          // Display values from 0 to 40
                          if (value % 5 == 0 && value >= 0 && value <= 40) {
                            return Text(
                              '${value.toInt()}', // Show integer value
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            );
                          }
                          return const SizedBox.shrink(); // Hide other values
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1, // Titles appear at every index
                        getTitlesWidget: (value, meta) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              '${value.toInt()}', // Show index value
                              style: const TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ), // Hide top axis
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: false,
                      ), // Hide right axis
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: const Border(
                      left: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ), // Left Y-axis
                      bottom: BorderSide(
                        color: Colors.black,
                        width: 1,
                      ), // Bottom X-axis
                      top: BorderSide.none, // Remove top X-axis
                      right: BorderSide.none, // Remove right Y-axis
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots:
                          numbers
                              .asMap()
                              .entries
                              .map((e) => FlSpot(e.key.toDouble(), e.value))
                              .toList(),
                      isCurved: true,
                      barWidth: 1, // Set line width to 1
                      color: Colors.orange,
                      dotData: FlDotData(show: false), // Hide dots
                    ),
                  ],
                  minY: 0, // Minimum Y-axis value
                  maxY: 40, // Maximum Y-axis value
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
