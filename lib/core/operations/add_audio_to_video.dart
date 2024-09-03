import 'package:poc_ffmpeg/core/models/operation_model.dart';
import 'package:poc_ffmpeg/core/operations/ffmpeg_operation.dart';

class AddAudioToVideo implements FFmpegOperation {
  final AddAudioToVideoConfig config;

  AddAudioToVideo(this.config);

  @override
  String generateCommand() {
    final videoPath = config.videoPath;
    final audioPath = config.audioPath;

    // Build the FFmpeg command to add audio to the video
    final addAudioCommand =
        '-i $videoPath -i $audioPath -c:v copy -c:a aac -strict experimental';

    return addAudioCommand;
  }
}
