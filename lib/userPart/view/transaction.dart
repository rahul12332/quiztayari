import 'package:fast_quiz_tayari/userPart/domain/sharedPre.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final String paymentId;

  TransactionHistoryScreen({required this.paymentId});

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String userEmail = "Fetching...";

  @override
  void initState() {
    super.initState();
    _fetchEmail();
  }

  void _fetchEmail() async {
    String? email = await SharedPrefs().getEmail();
    setState(() {
      userEmail = email!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction History")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "✅ Payment Successful!",
                style: GoogleFonts.acme(fontSize: 22, color: Colors.green),
              ),
            ),
            SizedBox(height: 20),
            _buildTransactionDetail("🔹 Payment ID:", widget.paymentId),
            _buildTransactionDetail("📧 Email:", userEmail),
            _buildTransactionDetail("📅 Pack Duration:", "6 Months"),
            _buildTransactionDetail("💰 Amount Paid:", "₹10"),
            SizedBox(height: 30),
            Center(
              child: GestureDetector(
                onTap: () => Navigator.pop(context), // Navigate back
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Back to Home",
                    style: GoogleFonts.acme(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            label,
            style: GoogleFonts.acme(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.acme(fontSize: 16, color: Colors.black87),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
