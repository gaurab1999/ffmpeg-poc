import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/video-features/feature.dart';

class LinkChallengeFeature extends Feature {
  final List<String> challenges;

  LinkChallengeFeature({
    required this.challenges,
    required super.position,
    required super.size,
    required super.editingFeatures,
    required super.isFFmpegNeeded,
    required super.onClickCallBack,
    super.id
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
        children: challenges.map((challenge) => Text(challenge)).toList(),
      ),
    );
  }

  @override
  String generateFFmpegCommand() {
    // TODO: implement generateFFmpegCommand
    throw UnimplementedError();
  }
}
