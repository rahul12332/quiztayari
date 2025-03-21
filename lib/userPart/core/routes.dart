import 'package:fast_quiz_tayari/userPart/view/RazorpayPaymentScreen.dart';
import 'package:fast_quiz_tayari/userPart/view/dasboard.dart';
import 'package:fast_quiz_tayari/userPart/view/login.dart';
import 'package:fast_quiz_tayari/userPart/view/mocktest.dart';
import 'package:fast_quiz_tayari/userPart/view/privacyPolicy.dart';
import 'package:fast_quiz_tayari/userPart/view/reviews.dart';
import 'package:fast_quiz_tayari/userPart/view/score.dart';
import 'package:fast_quiz_tayari/userPart/view/splashScreen.dart';
import 'package:flutter/material.dart';

import '../view/subjectmockList.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String mockTest = '/mockTest';
  static const String review = '/review'; // ✅ Added the review route
  static const String score = '/score';
  static const String razorPay = '/razorPay';
  static const String subjectMockList = '/subjectMockList';
  static const String privacyPolicy = '/privacy';
}

class AppRoutes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.privacyPolicy:
        return MaterialPageRoute(builder: (_) => PrivacyPolicyScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case Routes.dashboard:
        return MaterialPageRoute(builder: (_) => UserDasboard());
      case Routes.mockTest:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => Mocktest(
              subject: args['subject']!,
              mock: args['mock']!,
              subjectIndex:
                  args['subjectIndex'] as int, // Ensure it's cast as int
              mockIndex: args['mockIndex'] as int,
            ),
          );
        }
        return _errorRoute();
      case Routes.review:
        if (args is Map<String, String>) {
          return MaterialPageRoute(
            builder: (_) => Reviews(
              subject: args['subject']!,
              mock: args['mock']!,
            ),
          );
        }
        return _errorRoute();

      case Routes.score:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => ScoreChart(
              yourScore: args['score'],
              avgScore: args['avg'],
              topperScore: args['topper'],
              subject: args['subject'],
            ),
          );
        }
        return _errorRoute();
      case Routes.razorPay:
        return MaterialPageRoute(builder: (_) => RazorpayPaymentScreen());
      case Routes.subjectMockList:
        if (args is Map<String, dynamic>) {
          return MaterialPageRoute(
            builder: (_) => Subjectmocklist(
              subjectName: args['subjectName'],
              index: args['index'],
            ),
          );
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('No route defined')),
      ),
    );
  }
}
