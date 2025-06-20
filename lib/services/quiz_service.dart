import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/QuizQuestion.dart';
import '../model/quiz_category.dart';

class QuizService{
  // Fetch categories
  static Future<List<QuizCategory>> fetchCategories() async {
    final url = Uri.parse('https://opentdb.com/api_category.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> categoriesJson = data['trivia_categories'];

      return categoriesJson
          .map((json) => QuizCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch questions for a specific category
  static Future<List<QuizQuestion>> fetchQuizQuestions({required int categoryId}) async {
    final url = Uri.parse('https://opentdb.com/api.php?amount=20&type=multiple&category=$categoryId&difficulty=easy');
    final response = await http.get(url);

    if(response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> questionsJson = data['results'];

      return questionsJson
          .map((json) => QuizQuestion.fromJson(json))
          .toList();
    }else{
      throw Exception('Failed to load questions');
    }
  }
}