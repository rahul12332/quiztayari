import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/userPart/domain/sharedPre.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  @override
  _RazorpayPaymentScreenState createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();

    // Set up event listeners
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // Function to start payment
  void openCheckout() {
    var options = {
      'key': 'rzp_test_cg6qYa80j4CgD1', // Replace with your Razorpay Key
      'amount': 10 * 100, // Amount in paise (10 INR)
      'name': 'Fast Quiz Tayari',
      'description': 'Payment for 6-month course',
      'prefill': {
        'contact': '9458925957', // Pre-filled phone number
        'email': 'camit97chandra@gmail.com', // Pre-filled email
      },
      'external': {
        'wallets': ['paytm'], // Allow Paytm wallet
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  // Handle Payment Success

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      // Get user's email from shared preferences
      String? userEmail = await SharedPrefs().getEmail();

      if (userEmail == null || userEmail.isEmpty) {
        print("Error: User email is null or empty");
        return;
      }

      print("User Email: $userEmail"); // Debug log

      // Update Firestore: Add paymentStatus, paymentId, and other details inside users/userEmail
      await FirebaseFirestore.instance
          .collection("users") // Collection: users
          .doc(userEmail) // Document: userEmail
          .update({
        // Use `.update()` to modify an existing document
        "paymentStatus": true,
        "paymentId": response.paymentId,
        "amount": 10,
        "timestamp": FieldValue.serverTimestamp(),
      }).then((_) {
        print("Payment details successfully added to Firestore");
      }).catchError((error) {
        print("Error updating Firestore: $error");
      });

      // Show success message and redirect to Transaction History
      _showSuccessDialog(response.paymentId!);
    } catch (e) {
      print("Error in _handlePaymentSuccess: $e");
    }
  }

// Show success dialog

// Show success dialog
  void _showSuccessDialog(String paymentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            "✅ You have successfully purchased the 6-month course.\n💰 Price: ₹10\n\nPayment ID: $paymentId",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _navigateToTransactionHistory(context, paymentId);
              },
              child: Text("View Transaction"),
            ),
          ],
        );
      },
    );
  }

// Separate function to show the success dialog

// Dummy function for navigation (replace with actual implementation)
  void _navigateToTransactionHistory(BuildContext context, String paymentId) {
    print("Navigating to transaction history for Payment ID: $paymentId");
    // Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistoryScreen(paymentId: paymentId)));
  }

  // Payment Error Callback
  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.code} - ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  // External Wallet Callback
  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clean up the Razorpay instance
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Razorpay Payment")),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.shade300, blurRadius: 6, spreadRadius: 2),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Fast Quiz Tayari",
                style:
                    GoogleFonts.acme(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "✅ 6-month free courses\n✅ Practice sets included\n💰 Price: ₹10 only",
                textAlign: TextAlign.center,
                style: GoogleFonts.acme(fontSize: 16),
              ),
              SizedBox(height: 16),
              // Custom Pay Now button
              GestureDetector(
                onTap: openCheckout,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "Pay Now",
                      style:
                          GoogleFonts.acme(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🎯 Transaction History Screen
class TransactionHistoryScreen extends StatelessWidget {
  final String paymentId;

  TransactionHistoryScreen({required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction History")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("paymentStatus")
            .doc(paymentId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.data!.exists) {
            return Center(child: Text("No transaction found."));
          }

          var data = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("📩 Email: ${data['email']}",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("💳 Payment ID: ${data['paymentId']}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("📅 Date: ${data['timestamp'].toDate()}",
                    style: TextStyle(fontSize: 16)),
                SizedBox(height: 10),
                Text("💰 Amount Paid: ₹${data['amount']}",
                    style: TextStyle(fontSize: 16, color: Colors.green)),
              ],
            ),
          );
        },
      ),
    );
  }
}
