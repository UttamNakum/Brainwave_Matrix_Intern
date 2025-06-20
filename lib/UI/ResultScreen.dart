import 'package:flutter/material.dart';

import '../model/QuizQuestion.dart';
import 'category_selection_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int total;
  final List<QuizQuestion> questions;

  const ResultScreen({
    required this.score,
    required this.total,
    required this.questions
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //Background Image
          Positioned.fill(
            child: Image.asset(
              'images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          //Foreground Container
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                //Result Box
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.emoji_events_rounded, size: 60, color: Color.fromARGB(255, 243, 169, 58)),
                      SizedBox(height: 10),
                      Text(
                        "Quiz Completed!",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Your Score: $score / $total",
                        style: TextStyle(fontSize: 18, color: Colors.green[700]),
                      ),
                      SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => CategorySelectionScreen()),
                                (route) => false,
                          );
                        },
                        icon: Icon(Icons.restart_alt),
                        label: Text("Try Another Quiz"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 242, 184, 252),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                //Correct Answers List
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListView.builder(
                      itemCount: questions.length,
                      itemBuilder: (context, index) {
                        final question = questions[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Q${index + 1}: ${question.question}",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Correct Answer: ${question.correctAnswer}",
                                style: TextStyle(color: Colors.green[800]),
                              ),
                              Divider(thickness: 1),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
