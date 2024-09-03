import 'dart:io';

import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/services/media_processor.dart';
import 'package:poc_ffmpeg/utill/common_util.dart';
import 'package:poc_ffmpeg/video_player.dart';

class MediaEditorScreen extends StatefulWidget {
  final List<String> inputPath;
  const MediaEditorScreen({super.key, required this.inputPath});

  @override
  State<MediaEditorScreen> createState() => _MediaEditorScreenState();
}

class _MediaEditorScreenState extends State<MediaEditorScreen> {
  final MediaProcessor processor = MediaProcessor();
  final CommonUtil _commonUtil = CommonUtil();

  Future<void> ensureDirectoryExists(String directoryPath) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
  }

  void test() async {
    final processor = MediaProcessor();

    // Add operations
    // processor.addOperation(OperationFactory.createTrimOperation(
    //     const Duration(seconds: 5), const Duration(seconds: 15)));

    List<String> inputPath = widget.inputPath;

    final outputDirectory = _commonUtil.createTempDirectory();
    final outputPath = '$outputDirectory/output.mp4';
    // processor.addOperation(OperationFactory.createFilterOperation("vflip", ""));
    // processor.addOperation(
    //     OperationFactory.createVideoFromImageOperation(inputPath, outputPath));
    var resizedImages = await resizeImages(inputPath);
    var command = createCommoandForImagesToVideo(resizedImages, outputPath);
    print(command);
    await processor.execute(command);
    // testExecutor(inputPath, outputPath);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => VideoPlayerScreen(
                inputPath: outputPath,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Media Editor")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            test();
          },
          child: const Text("Process Media"),
        ),
      ),
    );
  }

  String createCommoandForImagesToVideo(List<String> inputpath, String output) {
    // Prepare input files for ffmpeg
    String inputs = inputpath
        .asMap()
        .entries
        .map((e) => '-loop 1 -t 5 -i ${e.value}')
        .join(' ');

    // Prepare filter_complex
    String filters =
        '${inputpath.asMap().entries.map((e) => '[${e.key}]scale=720:405,setsar=1,fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v${e.key}]').join('; ')}; ${inputpath.asMap().entries.map((e) => '[v${e.key}]').join('')}concat=n=${inputpath.length}:v=1:a=0,format=yuv420p[v]';

    // Return the complete ffmpeg command
    return '''$inputs -filter_complex "$filters" -map "[v]" -threads 4 -y $output''';
  }

  // Function to resize images
  Future<List<String>> resizeImages(List<String> inputFiles) async {
    final List<String> resizedImages = [];

    // Generate a unique path for the output directory
    final outputDirectory = _commonUtil.createTempDirectory();

    for (int i = 0; i < inputFiles.length; i++) {
      final inputFile = inputFiles[i];
      final outputPath = '$outputDirectory/resized_image_$i.jpg';
      // FFmpeg command to resize the image
      final command = '''
       -i $inputFile -vf scale=-1:1080 -aspect 16:9 $outputPath ''';
      final processor = MediaProcessor();
      await processor.execute(command);
      resizedImages.add(outputPath);
    }

    return resizedImages;
  }
}
