import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:poc_ffmpeg/core/services/media_processor.dart';
import 'package:poc_ffmpeg/editing_screen.dart';
import 'package:poc_ffmpeg/utill/common_util.dart';

class Singlefilepicker extends StatefulWidget {
  const Singlefilepicker({super.key});

  @override
  State<Singlefilepicker> createState() => _SinglefilepickerState();
}

class _SinglefilepickerState extends State<Singlefilepicker> {
  PlatformFile? file;
  final CommonUtil _commonUtil = CommonUtil();
  List<String> images = [];
  String audioPath = "";
  final Stopwatch stopwatch = Stopwatch();

  Future<void> pickImages() async {
    _commonUtil.openLoadingDialog(context);
    images = await _commonUtil.pickfile(
        allowMultiple: true, fileType: FileType.image);
    Get.back();
    setState(() {});
  }

  Future<void> pickVideo() async {    
    var video = await _commonUtil.pickfile(
        allowMultiple: false, fileType: FileType.video);
    Get.to(EditingScreen(inputPath: video.first));
  }

  Future<void> pickAudio() async {
    var result = await _commonUtil.pickfile(
        allowMultiple: false, fileType: FileType.audio);
    audioPath = result.first;
    setState(() {});
  }

  void _process() async {
    if (images.isEmpty) {
      _commonUtil.showSimpleDialog(
          context, "Images cann't be empty or select atlest 3 images");
      return;
    }
    if (audioPath.isEmpty) {
      _commonUtil.showSimpleDialog(context, "Audio can't be empty");
      return;
    }
    commitFfmpeg();
  }

  // Resize,
  // VideowithoutAudioWithAnimation,
  // AddAudiotoVideo

  void commitFfmpeg() async {
    _commonUtil.openLoadingDialog(context);
    stopwatch.start();
    final processor = MediaProcessor();
    log("Process: Fetching Temp Directory : ${stopwatch.elapsedMilliseconds} ms");
    final outputDirectory = await _commonUtil.createTempDirectory();
    final outputVideoWithoutAudio = '$outputDirectory/output.mp4';
    log("Process: Resizing Images Now : ${stopwatch.elapsedMilliseconds} ms");
    var resizedImages = await _resizeImages(images);
    log("Process: Done image resizing : ${stopwatch.elapsedMilliseconds} ms");
    var command =
        _createCommoandForImagesToVideo(resizedImages, outputVideoWithoutAudio);
    log("Process: Executing media processor command : ${stopwatch.elapsedMilliseconds} ms");
    await processor.execute(command);
    log("Process: Finished media processor command : ${stopwatch.elapsedMilliseconds} ms");
    String finalVideoPath = await _addAudioToVideo(outputVideoWithoutAudio);
    log("Process: Finished audio to video conversion : ${stopwatch.elapsedMilliseconds} ms");
    Get.back();
    log("Process: Redirecting with finalized video : ${stopwatch.elapsedMilliseconds} ms");
    stopwatch.stop();
    stopwatch.reset();
    Get.to(EditingScreen(inputPath: finalVideoPath));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [
              Color.fromARGB(255, 49, 168, 215),
              Color.fromARGB(255, 58, 207, 100)
            ])),
          ),
          title: const Text(
            'File Picker',
            style: TextStyle(
                color: Color.fromARGB(255, 59, 54, 54),
                fontWeight: FontWeight.bold,
                fontSize: 25),
          )),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    pickVideo();
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 255, 255, 255), // White background
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 0, 0, 0), // Black text
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Color.fromARGB(255, 0, 13, 255), // Red border
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.slow_motion_video_sharp,
                    size: 20,
                  ),
                  label: const Text(
                    'Pick Video',
                    style: TextStyle(fontSize: 18),
                  ),
                ),                
              ],
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    pickImages();
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 255, 255, 255), // White background
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 0, 0, 0), // Black text
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Color.fromARGB(255, 0, 13, 255), // Red border
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.image,
                    size: 20,
                  ),
                  label: const Text(
                    'Pick Images',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                if (images.isNotEmpty) const Text("Images Selected")
              ],
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    pickAudio();
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 255, 255, 255), // White background
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      Color.fromARGB(255, 0, 0, 0), // Black text
                    ),
                    side: WidgetStatePropertyAll(
                      BorderSide(
                        color: Color.fromARGB(255, 0, 13, 255), // Red border
                        width: 2.0, // Border width
                      ),
                    ),
                  ),
                  icon: const Icon(
                    Icons.audio_file,
                    size: 18,
                  ),
                  label: const Text(
                    'Pick Single Audio',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                if (audioPath.isNotEmpty) const Text("Audio Selected")
              ],
            ),
            ElevatedButton.icon(
              onPressed: () {
                _process();
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 255, 255, 255), // White background
                ),
                foregroundColor: WidgetStatePropertyAll(
                  Color.fromARGB(255, 0, 0, 0), // Black text
                ),
                side: WidgetStatePropertyAll(
                  BorderSide(
                    color: Color.fromARGB(255, 0, 13, 255), // Red border
                    width: 2.0, // Border width
                  ),
                ),
              ),
              icon: const Icon(
                Icons.confirmation_num,
                size: 20,
              ),
              label: const Text(
                'Process',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _createCommoandForImagesToVideo(
      List<String> inputpath, String output) {
    // Prepare input files for ffmpeg
    String inputs = inputpath
        .asMap()
        .entries
        .map((e) => '-loop 1 -t 5 -i ${e.value}')
        .join(' ');

  log("Process: New Created command for image to video : ${stopwatch.elapsedMilliseconds} ms");
    String filters =
      '${inputpath.asMap().entries.map((e) => '[${e.key}]scale=720:406,setsar=1,fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v${e.key}]').join('; ')}; ${inputpath.asMap().entries.map((e) => '[v${e.key}]').join('')}concat=n=${inputpath.length}:v=1:a=0,format=yuv420p[v]';

    return '''$inputs -c:v libx264 -crf 19 -filter_complex "$filters" -map "[v]" -threads 4 -loglevel debug -y $output''';
  }

  // Function to resize images
  Future<List<String>> _resizeImages(List<String> inputFiles) async {
    final List<String> resizedImages = [];

    // Generate a unique path for the output directory
    final outputDirectory = await _commonUtil.createTempDirectory();

    for (int i = 0; i < inputFiles.length; i++) {
      final inputFile = inputFiles[i];
      final outputPath = '$outputDirectory/resized_image_$i.jpg';
      // FFmpeg command to resize the image
      final command =
          "-i $inputFile -vf scale=-1:1080 -aspect 16:9 $outputPath ";
      final processor = MediaProcessor();
      await processor.execute(command);
      resizedImages.add(outputPath);
    }

    return resizedImages;
  }


  // Function to resize images
  Future<String> _addAudioToVideo(String videoPath) async {
    // Generate a unique path for the output directory
    log("Process: Start audio to video conversion : ${stopwatch.elapsedMilliseconds} ms");
    final outputDirectory = await _commonUtil.createTempDirectory();

    final finalOutputVidoePath = '$outputDirectory/final_video_output.mp4';
    // FFmpeg command to resize the image
    final command =
        "-i $videoPath -i $audioPath -c:v copy -c:a aac -b:a 192k -shortest $finalOutputVidoePath ";
    final processor = MediaProcessor();
    await processor.execute(command);

    return finalOutputVidoePath;
  }
}
