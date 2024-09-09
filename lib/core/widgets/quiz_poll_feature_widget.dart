import 'package:flutter/material.dart';

class QuizPollFeatureWidget extends StatefulWidget {
  final Function(String, List<String>) onSubmit;

  const QuizPollFeatureWidget({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _QuizPollFeatureWidgetState createState() => _QuizPollFeatureWidgetState();
}

class _QuizPollFeatureWidgetState extends State<QuizPollFeatureWidget> {
  TextEditingController questionController = TextEditingController();
  List<TextEditingController> optionControllers = List.generate(4, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quiz/Poll Feature",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          "Enter your question:",
          style: TextStyle(fontSize: 16),
        ),
        TextField(
          controller: questionController,
          decoration: const InputDecoration(
            hintText: "Type your question here",
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          "Enter options:",
          style: TextStyle(fontSize: 16),
        ),
        Column(
          children: List.generate(4, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: TextField(
                controller: optionControllers[index],
                decoration: InputDecoration(
                  hintText: "Option ${index + 1}",
                  border: const OutlineInputBorder(),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            List<String> options = optionControllers.map((controller) => controller.text).toList();
            widget.onSubmit(questionController.text, options);
          },
          child: const Text("Submit Quiz"),
        ),
      ],
    );
  }
}
