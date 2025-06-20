
// lib/models/quiz_question.dart
class QuizQuestion {
  final String question;
  final List<String> options;
  final String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    List<String> allOptions = List<String>.from(json['incorrect_answers']);
    allOptions.add(json['correct_answer']);
    allOptions.shuffle();

    return QuizQuestion(
      question: json['question'],
      options: allOptions,
      correctAnswer: json['correct_answer'],
    );
  }
}
