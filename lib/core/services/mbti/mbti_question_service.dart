import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../src/models/mbti/mbti_question_model.dart';

class MBTIQuestionService {
  static Future<List<MBTIQuestion>> getQuestions(String locale) async {
    try {
      final currentLocale = locale;
      final String jsonPath = 'lib/core/translations/$currentLocale.json';

      final String jsonString = await rootBundle.loadString(jsonPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);

      final Map<String, dynamic> questions = jsonData['mbti'];

      List<MBTIQuestion> questionList = [];

      questions.forEach((key, value) {
        questionList.add(MBTIQuestion(
          question: value['question'],
          optionA: value['optionA'],
          optionB: value['optionB'],
          category: value['category'],
        ));
      });

      return questionList;
    } catch (e) {
      print('Error loading questions: $e');
      throw Exception('Failed to load MBTI questions');
    }
  }
}
