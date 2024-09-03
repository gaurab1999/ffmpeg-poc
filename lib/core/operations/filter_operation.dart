import 'package:poc_ffmpeg/core/models/operation_model.dart';
import 'package:poc_ffmpeg/core/operations/ffmpeg_operation.dart';

class FilterOperation implements FFmpegOperation {
  final FilterConfig config;

  FilterOperation(this.config);

  @override
  String generateCommand() {
    return "-vf \"${config.filterName}=${config.filterParams}\"";
  }
}
