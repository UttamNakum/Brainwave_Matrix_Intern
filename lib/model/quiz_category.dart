class QuizCategory {
  final int id;
  final String name;

  QuizCategory({required this.id, required this.name});

  // Convert JSON to QuizCategory object
  factory QuizCategory.fromJson(Map<String, dynamic> json) {
    return QuizCategory(
      id: json['id'],
      name: json['name'],
    );
  }
}
