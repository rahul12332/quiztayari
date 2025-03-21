import 'package:flutter/material.dart';

import '../core/contant/appColor.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ), // iOS-style back button
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text("Privacy Policy"),
        backgroundColor: AppColor.theme, // Assuming AppColor.theme is defined
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(bottom: 40),
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              border: Border.all(color: AppColor.theme, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "Fast Quiz Tayari Privacy Policy\n\n"
              "Your privacy matters. Protect yourself with a secure VPN router.\n\n"
              "This privacy policy applies to the Fast Quiz Tayari app...\n\n"
              "Information Collection and Use\n\n"
              "The Application collects information when you download and use it...\n\n"
              "Third Party Access\n\n"
              "Only aggregated, anonymized data is periodically transmitted...\n\n"
              "Opt-Out Rights\n\n"
              "You can stop all collection of information by uninstalling the Application...\n\n"
              "Data Retention Policy\n\n"
              "The Service Provider will retain User Provided data for as long as you use the Application...\n\n"
              "Children\n\n"
              "The Service Provider does not use the Application to knowingly solicit data from children under 13...\n\n"
              "Security\n\n"
              "The Service Provider is concerned about safeguarding the confidentiality of your information...\n\n"
              "Changes\n\n"
              "This Privacy Policy may be updated from time to time...\n\n"
              "Your Consent\n\n"
              "By using the Application, you are consenting to the processing of your information...\n\n"
              "Contact Us\n\n"
              "If you have any questions regarding privacy, please contact the Service Provider at camit97chandra@gmail.com.",
              style: TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}
