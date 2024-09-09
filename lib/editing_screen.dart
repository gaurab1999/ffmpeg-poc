import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poc_ffmpeg/core/video-features/feature.dart';
import 'package:poc_ffmpeg/core/services/media_processor.dart';
import 'package:poc_ffmpeg/core/video-features/video_builder.dart';
import 'package:poc_ffmpeg/core/widgets/add_yours_feature_widget.dart';
import 'package:poc_ffmpeg/core/widgets/draw_feature_widget.dart';
import 'package:poc_ffmpeg/core/widgets/quiz_poll_feature_widget.dart';
import 'package:poc_ffmpeg/core/widgets/text_feature_widget.dart';
import 'package:poc_ffmpeg/feature_widget.dart';
import 'package:poc_ffmpeg/utill/common_util.dart';
import 'package:poc_ffmpeg/utill/enums.dart';
import 'package:poc_ffmpeg/video_player.dart';
import 'package:video_player/video_player.dart';

class EditingScreen extends StatefulWidget {
  final String inputPath;
  const EditingScreen({super.key, required this.inputPath});

  @override
  _EditingScreenState createState() => _EditingScreenState();
}

class _EditingScreenState extends State<EditingScreen> {
  final CommonUtil _commonUtil = CommonUtil();
  late VideoPlayerController _controller;
  final VideoBuilder videoBuilder = VideoBuilder();
  VideoEditingFeatures? selectedFeature;
  final Stopwatch stopwatch = Stopwatch();
  Feature? featureToUpdate;

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
      resizeToAvoidBottomInset: false,
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
          ...videoBuilder.getFeatureList().map((feature) => FeatureWidget(
              feature: feature, onUpdateFeature: addOrUpdateFeature)),
          // Vertical list of options
          Positioned(
            right: 8,
            top: 100,
            // bottom: 0,
            child: Container(
              width: 50,
              color: const Color.fromARGB(115, 152, 148, 148),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera),
                    onPressed: () {
                      addFeature(VideoEditingFeatures.addYours);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.list),
                    onPressed: () {
                      addFeature(VideoEditingFeatures.linkChallenge);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.draw),
                    onPressed: () {
                      addFeature(VideoEditingFeatures.draw);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.text_fields),
                    onPressed: () {
                      addFeature(VideoEditingFeatures.text);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.poll),
                    onPressed: () {
                      addFeature(VideoEditingFeatures.quizPoll);
                    },
                  ),
                  // Add more buttons for other features
                ],
              ),
            ),
          ),
          if (selectedFeature != null)
            Container(
                color: Colors.black54,
                child: _buildFeatureContent(
                    existingFeature: featureToUpdate,
                    feature: selectedFeature!))
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

  void addFeature(VideoEditingFeatures editingFeature) {
    setState(() {
      selectedFeature = editingFeature;
    });
  }

  Widget _buildFeatureContent(
      {required VideoEditingFeatures feature, Feature? existingFeature}) {
    switch (feature) {
      case VideoEditingFeatures.text:
        return TextFeatureWidget(
          existingFeature: existingFeature,
          onClickCallback: (Feature existingData) {
            setState(() {
              featureToUpdate = existingData;
            });
            addFeature(feature);
          },
          callback: addOrUpdateFeature,
        );
      case VideoEditingFeatures.addYours:
        return AddYoursFeatureWidget(
          callback: addOrUpdateFeature,
        );
      case VideoEditingFeatures.draw:
        return DrawFeatureWidget(onChanged: (value) {});
      case VideoEditingFeatures.quizPoll:
        return QuizPollFeatureWidget(
            onSubmit: (String question, List<String> options) {});
      default:
        return const Text("Feature not supported");
    }
  }

  void addOrUpdateFeature(Feature updatedFeature) {
    log("Called here update");
    int index = videoBuilder
        .getFeatureList()
        .indexWhere((feature) => feature.id == updatedFeature.id);
    if (index != -1) {
      setState(() {
        videoBuilder.updateFeatureAt(index, updatedFeature);
      });
    } else {
      setState(() {
        videoBuilder.addFeature(updatedFeature);
      });
    }

    // reset selected feature
    setState(() {
      selectedFeature = null;
    });
  }

  Future<void> finalizeVideo() async {
    stopwatch.start();
    _commonUtil.openLoadingDialog(context);
    log('Process: Started process of finalizing video: ${stopwatch.elapsedMilliseconds} ms');
    final inputVideoPath = widget.inputPath;
    log('Process: Creating temp directory: ${stopwatch.elapsedMilliseconds} ms');
    final outputDirectory = await _commonUtil.createTempDirectory();
    final outputVideoPath = '$outputDirectory/output.mp4';
    log('Process: Creating ffmpeg command from features : ${stopwatch.elapsedMilliseconds} ms');
    // Get the actual video dimensions
    String ffmpegCommand = getFFmpegCommand(inputVideoPath, outputVideoPath);
    log('Command has been finalized: $ffmpegCommand');
    final processor = MediaProcessor();
    log('Process: Starting ffmpeg command : ${stopwatch.elapsedMilliseconds} ms');
    await processor.execute(ffmpegCommand);
    log('Process: Finished ffmpeg command : ${stopwatch.elapsedMilliseconds} ms');
    stopwatch.stop();
    stopwatch.reset();
    Get.back();
    log('Video finalized and saved to $outputVideoPath');
    Get.to(() => VideoPlayerScreen(inputPath: outputVideoPath));
  }

  String getFFmpegCommand(String inputVideoPath, String outputVideoPath) {
    final videoWidth = _controller.value.size.width;
    final videoHeight = _controller.value.size.height;

    // Get the dimensions of the widget displaying the video
    final widgetWidth = MediaQuery.of(context).size.width;
    final widgetHeight = widgetWidth / _controller.value.aspectRatio;
    final ffmpegCommand = videoBuilder.buildFFmpegCommand(
        inputVideoPath: inputVideoPath,
        outputVideoPath: outputVideoPath,
        videoOffset: Offset(videoWidth, videoHeight),
        widgetOffset: Offset(widgetWidth, widgetHeight));
    return ffmpegCommand;
  }
}
