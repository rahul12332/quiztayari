import 'dart:isolate';

import 'package:fast_quiz_tayari/userPart/repostory/firebaseApi.dart';

class FirebaseIsolate {
  static Future<List<Map<String, dynamic>>> fetchSeriesDataWithIsolate() async {
    final receivePort = ReceivePort();
    await Isolate.spawn(MyDb.fetchSeriesIsolate, receivePort.sendPort);
    return await receivePort.first;
  }
}
