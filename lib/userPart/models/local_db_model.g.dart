// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:hive/hive.dart';

import 'hive_series_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestionModelAdapter extends TypeAdapter<QuestionModel> {
  @override
  final int typeId = 0;

  @override
  QuestionModel read(BinaryReader reader) {
    return QuestionModel(
      question: reader.readString(),
      options: reader.readList().cast<String>(),
      correctAnswer: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, QuestionModel obj) {
    writer.writeString(obj.question);
    writer.writeList(obj.options);
    writer.writeString(obj.correctAnswer);
  }
}

class MockModelAdapter extends TypeAdapter<MockModel> {
  @override
  final int typeId = 1;

  @override
  MockModel read(BinaryReader reader) {
    return MockModel(
      mockName: reader.readString(),
      questions: reader.readList().cast<QuestionModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, MockModel obj) {
    writer.writeString(obj.mockName);
    writer.writeList(obj.questions);
  }
}

class SeriesModelAdapter extends TypeAdapter<SeriesModel> {
  @override
  final int typeId = 2;

  @override
  SeriesModel read(BinaryReader reader) {
    return SeriesModel(
      subjectName: reader.readString(),
      mocks: reader.readList().cast<MockModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SeriesModel obj) {
    writer.writeString(obj.subjectName);
    writer.writeList(obj.mocks);
  }
}
