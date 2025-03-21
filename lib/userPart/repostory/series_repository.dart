import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../models/hive_series_model.dart';

class SeriesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<SeriesModel>> fetchSeries() async {
    try {
      QuerySnapshot seriesSnapshot =
          await _firestore.collection('series').get();
      List<SeriesModel> seriesList = [];

      for (var seriesDoc in seriesSnapshot.docs) {
        String subjectName = seriesDoc.id;
        QuerySnapshot mockSnapshot =
            await _firestore.collection('series/$subjectName/mocks').get();

        Map<String, List<Map<String, dynamic>>> mockData = {};

        for (var mockDoc in mockSnapshot.docs) {
          String mockName = mockDoc.id;
          QuerySnapshot questionSnapshot = await _firestore
              .collection('series/$subjectName/mocks/$mockName/questions')
              .get();

          List<Map<String, dynamic>> questionList = questionSnapshot.docs
              .map((doc) => doc.data() as Map<String, dynamic>)
              .toList();

          mockData[mockName] = questionList;
        }

        seriesList.add(SeriesModel.fromFirestore(subjectName, mockData));
      }

      return seriesList;
    } catch (e) {
      print("Error fetching series: $e");
      return [];
    }
  }

  // Store data in Hive
  Future<void> saveSeriesToHive(List<SeriesModel> seriesList) async {
    var box = await Hive.openBox<SeriesModel>('FastQuizTayari');
    await box.clear(); // Clear previous data
    await box.addAll(seriesList);
  }

  // Retrieve data from Hive
  Future<List<SeriesModel>> getSeriesFromHive() async {
    var box = await Hive.openBox<SeriesModel>('FastQuizTayari');
    return box.values.toList();
  }
}
