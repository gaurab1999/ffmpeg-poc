import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poc_ffmpeg/core/models/add_yours_feature.dart';
import 'package:poc_ffmpeg/core/models/draw_feature.dart';
import 'package:poc_ffmpeg/core/models/feature.dart';
import 'package:poc_ffmpeg/core/models/link_challenge_feature.dart';
import 'package:poc_ffmpeg/core/models/quiz_feature.dart';
import 'package:poc_ffmpeg/core/models/text_feature.dart';
import 'package:poc_ffmpeg/core/services/media_processor.dart';
import 'package:poc_ffmpeg/feature_widget.dart';
import 'package:poc_ffmpeg/utill/common_util.dart';
import 'package:poc_ffmpeg/video_player.dart';
import 'package:video_player/video_player.dart';

class EditingScreen extends StatefulWidget {
  final String inputPath;
  const EditingScreen({super.key, required this.inputPath});

  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  List<Feature> features = [];
  final CommonUtil _commonUtil = CommonUtil();
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.inputPath))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          // Video or background goes here
          ...features.map((feature) =>
              FeatureWidget(feature: feature, onUpdateFeature: updateFeature)),
          // Vertical list of options
          Positioned(
            right: 8,
            top: 100,
            // bottom: 0,
            child: Container(
              width: 50,
              color: Colors.black45,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera),
                    onPressed: () {
                      addFeature(AddYoursFeature(
                        profileImageUrl: 'https://example.com/profile.jpg',
                        textController: TextEditingController(),
                        position: const Offset(100, 10),
                        size: 1.0,
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: () {
                      addFeature(LinkChallengeFeature(
                        challenges: ['Challenge 1', 'Challenge 2'],
                        position: const Offset(150, 150),
                        size: 1.0,
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.poll),
                    onPressed: () {
                      addFeature(QuizPollFeature(
                        question: 'What is your favorite color?',
                        options: ['Red', 'Blue', 'Green', 'Yellow'],
                        selectedOption: ValueNotifier<String?>(null),
                        position: const Offset(200, 200),
                        size: 1.0,
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.draw),
                    onPressed: () {
                      addFeature(DrawFeature(
                        color: Colors.red,
                        points: [const Offset(10, 10)],
                        strokeWidth: 1.0,
                        position: const Offset(200, 200),
                        size: 1.0,
                      ));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.text_fields),
                    onPressed: () {
                      addFeature(TextFeature(
                          text: "hello",
                          position: const Offset(200, 200),
                          size: 10.0,
                          textStyle: const TextStyle(
                              color: Colors.black, fontSize: 24)));
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.poll),
                    onPressed: () {
                      addFeature(QuizPollFeature(
                        question: 'What is your favorite color?',
                        options: ['Red', 'Blue', 'Green', 'Yellow'],
                        selectedOption: ValueNotifier<String?>(null),
                        position: const Offset(200, 200),
                        size: 1.0,
                      ));
                    },
                  ),
                  // Add more buttons for other features
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            onPressed: () {
              finalizeVideo();
            },
            child: const Icon(Icons.done),
          ),
        ],
      ),
    );
  }

  void addFeature(Feature feature) {
    setState(() {
      features.add(feature);
    });
  }

  void updateFeature(Feature updatedFeature) {
    setState(() {
      int index = features.indexWhere((feature) => feature == updatedFeature);
      if (index != -1) {
        features[index] = updatedFeature;
      }
    });
  }

  Future<void> finalizeVideo() async {
    final inputVideoPath = widget.inputPath;
    final outputDirectory = await _commonUtil.createTempDirectory();
    final outputVideoPath = '$outputDirectory/final_video_output.mp4';

    final ffmpegCommand =
        generateFFmpegCommand(inputVideoPath, features, outputVideoPath);
    log('Command has been finalized: $ffmpegCommand');
    final processor = MediaProcessor();
    await processor.execute(ffmpegCommand);
    log('Video finalized and saved to $outputDirectory');
    Get.to(VideoPlayerScreen(inputPath: outputDirectory));
  }

  String generateFFmpegCommand(
      String inputVideoPath, List<Feature> features, String outputVideoPath) {
    // Base command
    String command = '-i $inputVideoPath';

    // Generate overlay commands for each feature
    String overlayCommands = features
        .map((feature) {
          final position = feature.position;

          // Example command for each feature type; adjust as needed
          if (feature is AddYoursFeature) {
            // Implement your command for AddYoursFeature
            return ''; // Placeholder: implement as needed
          } else if (feature is LinkChallengeFeature) {
            // Implement your command for LinkChallengeFeature
            return ''; // Placeholder: implement as needed
          } else if (feature is QuizPollFeature) {
            // Implement your command for QuizPollFeature
            return ''; // Placeholder: implement as needed
          } else if (feature is TextFeature) {
            final text = feature.text;
            final fontSize = (feature.textStyle.fontSize ?? 20.0)
                .toInt(); // Default to 20 if not set
            final color = feature.textStyle.color?.toHex() ??
                'white'; // Default to white if not set

            // Return drawtext command
            return "drawtext=text='Hello World':x=10:y=10:fontsize=24:fontcolor=black:box=1:boxcolor=black:boxborderw=5";
          }

          return ''; // No command for unrecognized feature
        })
        .where((cmd) => cmd.isNotEmpty)
        .join(',');

    // Complete the command
    command += ' -vf "$overlayCommands" -y $outputVideoPath';

    return command;
  }
}
