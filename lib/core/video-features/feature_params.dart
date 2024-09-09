// Define a base class for all feature parameters
import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/utill/enums.dart';

abstract class FeatureParams {
  String? id;
  Offset position;
  double size;
  VideoEditingFeatures editingFeatures;
  bool isFFmpegNeeded;
  Function onClickCallBack;

  FeatureParams({
    required this.position,
    required this.size,
    required this.editingFeatures,
    required this.isFFmpegNeeded,
    required this.onClickCallBack,
    this.id,
  });
}

// Other parameter classes
class TextParams extends FeatureParams {
  final String text;
  final TextStyle textStyle;
  final String fontPath;

  TextParams({
    required this.text,
    required this.textStyle,
    required super.position,
    required super.size,
    required super.editingFeatures,
    required super.isFFmpegNeeded,
    required this.fontPath,
    required super.onClickCallBack,
    super.id,
  });
}

// Other parameter classes
class QuizPollParams extends FeatureParams {
  final String question;
  final List<String> options;
  final ValueNotifier<String?> selectedOption;

  QuizPollParams({
    required this.question,
    required this.options,
    required this.selectedOption,
    required super.position,
    required super.size,
    required super.editingFeatures,
    required super.isFFmpegNeeded,
    required super.onClickCallBack,
    super.id,
  });
}

// Parameters for Add Yours Feature
class AddYoursParams extends FeatureParams {
  final String profileImageUrl;
  final TextEditingController textController;

  AddYoursParams({
    required this.profileImageUrl,
    required this.textController,
    required super.position,
    required super.size,
    required super.editingFeatures,
    required super.isFFmpegNeeded,
    required super.onClickCallBack,
    super.id,
  });
}

// Other parameter classes
class DrawParams extends FeatureParams {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawParams({
    required this.points,
    required this.color,
    required this.strokeWidth,
    required super.position,
    required super.size,
    required super.editingFeatures,
    required super.isFFmpegNeeded,
    required super.onClickCallBack,
    super.id,
  });
}

class LinkChallengeParams extends FeatureParams {
  final List<String> challenges;

  LinkChallengeParams({
    required this.challenges,
    required super.position,
    required super.size,
    required super.editingFeatures,
    required super.isFFmpegNeeded,
    required super.onClickCallBack,
    super.id,
  });
}
