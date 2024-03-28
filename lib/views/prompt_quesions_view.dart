import 'package:flutter/material.dart';

class PromptQuestions extends StatelessWidget {
  final List<String> questions;

  const PromptQuestions({Key? key, required this.questions}) : super(key: key);

  Widget questionCard(String question) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(question),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text("You may select one of the following questions to respond to:",
          style: TextStyle(fontSize: 16 ),
        ),
          ...questions.map((e) => questionCard(e)),
        const SizedBox(height: 8),
      ],
    );
  }
}