import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/utill/enums.dart';
import 'package:uuid/uuid.dart';

abstract class Feature {
  String id;
  Offset position;
  double size;
  VideoEditingFeatures editingFeatures;
  bool isFFmpegNeeded;
  Function onClickCallBack;

  Feature({
    String? id,  // Option to pass a custom ID if needed
    required this.position,
    required this.size,
    required this.editingFeatures,
    required this.isFFmpegNeeded,
    required this.onClickCallBack,
  }) : id = id ?? const Uuid().v4(); // Generate a UUID if no ID is provided

  // Method to render the feature
  Widget render();

  // Method to generate FFmpeg command
  String generateFFmpegCommand();
}
