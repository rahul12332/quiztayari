import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fast_quiz_tayari/userPart/core/app_theme.dart';
import 'package:fast_quiz_tayari/userPart/core/contant/appColor.dart';
import 'package:fast_quiz_tayari/userPart/core/routes.dart';
import 'package:fast_quiz_tayari/userPart/models/hive_series_model.dart';
import 'package:fast_quiz_tayari/userPart/models/local_db_model.g.dart';
import 'package:fast_quiz_tayari/userPart/repostory/localDb_repository.dart';
import 'package:fast_quiz_tayari/userPart/repostory/series_repository.dart';
import 'package:fast_quiz_tayari/userPart/view/splashScreen.dart';
import 'package:fast_quiz_tayari/userPart/widgets/internetchecker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      systemNavigationBarColor: AppColor.theme, // Set navigation bar color
      systemNavigationBarIconBrightness:
          Brightness.light, // Set icon brightness
      statusBarColor: AppColor.theme, // Set status bar color
      statusBarIconBrightness:
          Brightness.light, // Set status bar icon brightness
    ),
  );
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: false,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(QuestionModelAdapter());
  Hive.registerAdapter(MockModelAdapter());
  Hive.registerAdapter(SeriesModelAdapter());
  var box = await Hive.openBox<SeriesModel>('FastQuizTayari');
  if (box.isEmpty) {
    print("Fetching and storing data in Hive...");
    await fetchAndStoreData();
  } else {
    print("Data already exists in Hive.");
  }

  await box.close();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
          create: (_) => InternetService()), // ✅ Internet Checker globally
    ],
    child: const MyApp(),
  ));
}

Future<void> fetchAndStoreData() async {
  SeriesRepository repository = SeriesRepository();
  HiveRepository hiveRepository = HiveRepository();

  List<SeriesModel> fetchedData = await repository.fetchSeries();
  await hiveRepository.storeSeriesData(fetchedData);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fast Quiz Tayari',
      theme: AppTheme.themeData,
      home: SplashScreen(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
