import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/video-features/feature.dart';
import 'package:poc_ffmpeg/core/video-features/text_feature.dart';

class VideoBuilder {
  final List<Feature> _features = [];

  void addFeature(Feature feature) {
    _features.add(feature);
  }

  void updateFeatureAt(int index, Feature feature) {
    print("called updateFeatureAt");
    _features[index] = feature;
  }

  void removeFeature(Feature feature) {
    _features.remove(feature);
  }

  void removeAt(int index) {
    _features.removeAt(index);
  }

  List<Feature> getFeatureList() {
    return _features;
  }

  String buildFFmpegCommand({
    required String inputVideoPath,
    required String outputVideoPath,
    required Offset videoOffset,
    required Offset widgetOffset,
  }) {
    String baseCommand = '-i $inputVideoPath';

    // Build the filter graph for FFmpeg
    String filterGraph = _features
        .map((feature) {
          Feature updatedFeature = feature;
          final videoPosX =
              (feature.position.dx / widgetOffset.dx) * videoOffset.dx;
          final videoPosY =
              (feature.position.dy / widgetOffset.dy) * videoOffset.dy;
          if (feature is TextFeature) {
            updatedFeature = feature.copyWith(
              position: Offset(videoPosX, videoPosY),
              size: (24 / widgetOffset.dx) * videoOffset.dx,
            );
          }
          return updatedFeature.generateFFmpegCommand();
        })
        .where((cmd) => cmd.isNotEmpty)
        .join(',');

    // Final command with overlays
    baseCommand +=
        ' ${filterGraph.isEmpty ? "" : "-vf"} "$filterGraph" -c:v libx264 -preset veryfast -crf 23 -c:a copy -y $outputVideoPath';
    return baseCommand;
  }
}
