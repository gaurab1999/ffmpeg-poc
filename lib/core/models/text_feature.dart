import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/models/feature.dart';

class TextFeature extends Feature {
  final String text;
  final TextStyle textStyle;

  TextFeature({
    required this.text,
    required this.textStyle,
    required super.position,
    required super.size,
  });

  @override
  Widget render() {
    return Text(
      text,
      style: textStyle,
    );
  }
}
