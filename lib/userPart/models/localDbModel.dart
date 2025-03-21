class QuestionModel {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuestionModel({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  // Convert Firestore document to QuestionModel
  factory QuestionModel.fromMap(Map<String, dynamic> data) {
    return QuestionModel(
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'] ?? '',
    );
  }
}

class MockModel {
  final String mockName;
  final List<QuestionModel> questions;

  MockModel({
    required this.mockName,
    required this.questions,
  });

  // Convert Firestore data to MockModel
  factory MockModel.fromFirestore(
      String mockName, List<Map<String, dynamic>> questionDocs) {
    return MockModel(
      mockName: mockName,
      questions: questionDocs.map((q) => QuestionModel.fromMap(q)).toList(),
    );
  }
}

class SeriesModel {
  final String subjectName;
  final List<MockModel> mocks;

  SeriesModel({
    required this.subjectName,
    required this.mocks,
  });

  // Convert Firestore data to SeriesModel
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
