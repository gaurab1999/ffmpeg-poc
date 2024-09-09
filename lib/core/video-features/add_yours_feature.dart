import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/video-features/feature.dart';

class AddYoursFeature extends Feature {
  final String profileImageUrl;
  final TextEditingController textController;

  AddYoursFeature({
    required this.profileImageUrl,
    required this.textController,
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
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileImageUrl),
            radius: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Add yours...',
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  @override
  String generateFFmpegCommand() {
    // TODO: implement generateFFmpegCommand
    throw UnimplementedError();
  }
}
