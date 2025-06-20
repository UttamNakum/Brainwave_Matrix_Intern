import 'package:flutter/material.dart';
import 'package:quiz_app/model/quiz_category.dart';
import 'package:quiz_app/services/quiz_service.dart';

import 'QuizScreen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  
  List<QuizCategory> categories = [];
  bool isLoading = true;
  QuizCategory? selectedCategory;
  
  @override
  void initState() {
    super.initState();
    fetchCategories();
  }
  
  Future<void> fetchCategories() async {
    try{
      final data = await QuizService.fetchCategories();
      setState(() {
        categories =data;
        selectedCategory = categories.first;
        isLoading = false;
      });
    }catch(e){
      print('Error fetching categories: $e');
    }
  }

  void startQuiz() {
    if(selectedCategory != null){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(categoryId: selectedCategory!.id),
        ),
      );
    }
  }
  
 /* @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Center(child: CircularProgressIndicator())
          :Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<QuizCategory>(
              value: selectedCategory,
              isExpanded: true,
              items: categories.map((category){
                return DropdownMenuItem<QuizCategory>(
                  value: category,
                  child: Text(category.name),
                );
              }).toList(),
              onChanged: (value){
                setState(() {
                  selectedCategory = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: startQuiz,
              child: Text('Start Quiz'),
            )
          ],
        )
      )
    );
  }*/
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
              'images/background.png', // ✅ Make sure this path exists
              fit: BoxFit.cover,
            ),
          ),

          //Foreground content inside semi-transparent container
          Center(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.85),
                borderRadius: BorderRadius.circular(20),
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
                children: [
                  Text(
                    'Select Quiz Category',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButton<QuizCategory>(
                    value: selectedCategory,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    items: categories.map((category) {
                      return DropdownMenuItem<QuizCategory>(
                        value: category,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCategory = value;
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 243, 184, 252),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: startQuiz,
                    child: Text(
                      'Start Quiz',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
