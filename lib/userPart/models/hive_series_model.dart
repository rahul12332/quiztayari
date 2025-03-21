import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class QuestionModel {
  @HiveField(0)
  final String question;

  @HiveField(1)
  final List<String> options;

  @HiveField(2)
  final String correctAnswer;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuestionModel.fromMap(Map<String, dynamic> data) {
    return QuestionModel(
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
    );
  }
}

@HiveType(typeId: 1)
class MockModel {
  @HiveField(0)
  final String mockName;

  @HiveField(1)
  final List<QuestionModel> questions;

  MockModel({
    required this.mockName,
    required this.questions,
  });

  factory MockModel.fromFirestore(
      String mockName, List<Map<String, dynamic>> questionDocs) {
    return MockModel(
      mockName: mockName,
      questions: questionDocs.map((q) => QuestionModel.fromMap(q)).toList(),
    );
  }
}

@HiveType(typeId: 2)
class SeriesModel {
  @HiveField(0)
  final String subjectName;

  @HiveField(1)
  final List<MockModel> mocks;

  SeriesModel({
    required this.subjectName,
    required this.mocks,
  });

  factory SeriesModel.fromFirestore(
      String subjectName, Map<String, List<Map<String, dynamic>>> mockData) {
    return SeriesModel(
      subjectName: subjectName,
      mocks: mockData.entries.map((entry) {
        return MockModel.fromFirestore(entry.key, entry.value);
      }).toList(),
    );
  }
}
