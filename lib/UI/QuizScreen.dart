import 'package:flutter/material.dart';
import 'package:quiz_app/services/quiz_service.dart';

import '../model/QuizQuestion.dart';
import 'ResultScreen.dart';

class QuizScreen extends StatefulWidget {
  final int categoryId;

  const QuizScreen({required this.categoryId});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    try{
      final data = await QuizService.fetchQuizQuestions(categoryId : widget.categoryId);
      setState(() {
        questions = data;
        isLoading = false;
      });
    }catch(e){
      print('Error loading questions: $e');
    }
  }

  void checkAnswer(String selectedOption) {
    final currentQuestion = questions[currentQuestionIndex];

    if (selectedOption == currentQuestion.correctAnswer) {
      score++;
    }

    if(currentQuestionIndex < questions.length - 1){
      setState(() {
        currentQuestionIndex++;
      });
    }else{
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(score: score, total: questions.length, questions: questions)
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          //Background Image
          Positioned.fill(
            child: Image.asset(
              'images/background.png', // ✅ Make sure this image exists in your assets
              fit: BoxFit.cover,
            ),
          ),

          //Foreground content
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Q${currentQuestionIndex + 1}/${questions.length}",
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 16),
                    Text(
                      questions[currentQuestionIndex].question,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    ...questions[currentQuestionIndex].options.map((option) {
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ElevatedButton(
                          onPressed: () => checkAnswer(option),
                          child: Text(option),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 242, 184, 252),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}