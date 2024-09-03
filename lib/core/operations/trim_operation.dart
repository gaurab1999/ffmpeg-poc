import 'package:poc_ffmpeg/core/models/operation_model.dart';
import 'package:poc_ffmpeg/core/operations/ffmpeg_operation.dart';

class TrimOperation implements FFmpegOperation {
  final TrimConfig config;

  TrimOperation(this.config);

  @override
  String generateCommand() {
    return "-ss ${config.startTime.inSeconds} -to ${config.endTime.inSeconds}";
  }
}
