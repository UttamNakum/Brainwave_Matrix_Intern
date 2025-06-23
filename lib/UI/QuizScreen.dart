import 'dart:async';

import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:quiz_app/services/quiz_service.dart';

import '../model/QuizQuestion.dart';
import 'ResultScreen.dart';

class QuizScreen extends StatefulWidget {
  final List<QuizQuestion> questions;

  QuizScreen({required this.questions});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> with SingleTickerProviderStateMixin {
  List<QuizQuestion> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  bool isLoading = true;
  late Timer timer;
  int timeLeft = 15;
  double percent = 1.0;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;


  @override
  void initState() {
    super.initState();

    _shakeController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _shakeAnimation = Tween<double>(begin: 0, end: 8).chain(CurveTween(curve: Curves.elasticIn)).animate(_shakeController);

    startTimer();
  }

  void startTimer() {
    timeLeft = 30;
    percent = 1.0;
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        timeLeft--;
        percent = timeLeft / 30;
        if (timeLeft <= 0) {
          timer.cancel();
          moveToNextQuestion(); // auto-skip or mark incorrect
        }
        if (timeLeft <=8 ) {
          _shakeController.forward(from: 0); // 🔔 Start shake
        }
      });
    });
  }

  void moveToNextQuestion() {
    if (currentQuestionIndex < widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
      startTimer(); // reset timer for next question
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(
            score: score,
            total: widget.questions.length,
            questions: widget.questions,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    _shakeController.dispose();
    super.dispose();
  }

  void checkAnswer(String selected) {
    timer.cancel();
    final currentQuestion = widget.questions[currentQuestionIndex];
    if (selected == currentQuestion.correctAnswer) {
      score++;
    }
    moveToNextQuestion();
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[currentQuestionIndex];

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('images/background.png', fit: BoxFit.cover),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 🔄 Timer & Question Number
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Q${currentQuestionIndex + 1}/${widget.questions.length}",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    AnimatedBuilder(
                      animation: _shakeAnimation,
                      builder: (BuildContext context, Widget? child) {
                        return Transform.translate(
                          offset: Offset(_shakeAnimation.value,0),
                          child: CircularPercentIndicator(
                          radius: 30.0,
                          lineWidth: 6.0,
                          percent: percent.clamp(0.0, 1.0),
                          center: Text("$timeLeft s"),
                          progressColor: timeLeft <= 10 ? Colors.red : Colors.green,
                          backgroundColor: Colors.grey,
                        ),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // 🔹 Question Text
                Text(
                  question.question,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                // 🔘 Options
                ...question.options.map((option) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ElevatedButton(
                      onPressed: () => checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        backgroundColor:Color.fromARGB(255, 243, 184, 252),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(option),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}