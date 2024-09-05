import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/models/feature.dart';

class LinkChallengeFeature extends Feature {
  final List<String> challenges;

  LinkChallengeFeature({
    required this.challenges,
    required super.position,
    required super.size,
  });

  @override
  Widget render() {
    return Container(
      padding: EdgeInsets.all(8.0),
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
}
