import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'contant/appColor.dart';

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
        primaryColor: AppColor.theme,
        scaffoldBackgroundColor: AppColor.bg,
        appBarTheme: AppBarTheme(
          backgroundColor: AppColor.theme,
          titleTextStyle: GoogleFonts.acme(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: AppColor.buttonColor,
        ),
        textTheme: GoogleFonts.adaminaTextTheme());
  }
}
