import 'package:hive/hive.dart';

import '../models/hive_series_model.dart';

class HiveRepository {
  static const String boxName = "FastQuizTayari";

  Future<void> storeSeriesData(List<SeriesModel> seriesList) async {
    var box = await Hive.openBox<SeriesModel>(boxName);
    await box.clear(); // Clear old data before saving new
    await box.addAll(seriesList);
  }

  Future<List<SeriesModel>> getSeriesData() async {
    var box = Hive.isBoxOpen(boxName)
        ? Hive.box<SeriesModel>(boxName)
        : await Hive.openBox<SeriesModel>(boxName); // ✅ Open if not opened
    return box.values.toList();
  }
}
