import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/models/feature.dart';

class QuizPollFeature extends Feature {
  final String question;
  final List<String> options;
  final ValueNotifier<String?> selectedOption;

  QuizPollFeature({
    required this.question,
    required this.options,
    required this.selectedOption,
    required super.position,
    required super.size,
  });

  @override
  Widget render() {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          ...options.map((option) => ValueListenableBuilder<String?>(
                valueListenable: selectedOption,
                builder: (context, selected, child) {
                  return Row(
                    children: [
                      Radio<String>(
                        value: option,
                        groupValue: selected,
                        onChanged: (value) {
                          selectedOption.value = value!;
                        },
                      ),
                      Text(option),
                    ],
                  );
                },
              )),
        ],
      ),
    );
  }
}
