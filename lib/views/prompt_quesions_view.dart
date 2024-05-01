import 'package:flutter/material.dart';

class PromptQuestions extends StatefulWidget {
  final List<String> questions;
  final Function(String?) onQuestionSelected;

  const PromptQuestions({
    Key? key,
    required this.questions,
    required this.onQuestionSelected,
  }) : super(key: key);

  @override
  _PromptQuestionsState createState() => _PromptQuestionsState();
}

class _PromptQuestionsState extends State<PromptQuestions> {
  String? selectedQuestion;

  Widget questionCard(String question) {
    final isSelected = selectedQuestion == question;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedQuestion = isSelected? null: question;
        });
        widget.onQuestionSelected(question);
      },
      child: Card(
        color: isSelected ? Colors.blue[100] : null,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(question),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 8),
        const Text(
          "You may select one of the following questions to respond to:",
          style: TextStyle(fontSize: 16),
        ),
        ...widget.questions.map((e) => questionCard(e)),
        const SizedBox(height: 8),
      ],
    );
  }
}