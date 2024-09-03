import 'package:poc_ffmpeg/core/models/operation_model.dart';
import 'package:poc_ffmpeg/core/operations/create_video_from_images_operation.dart';
import 'package:poc_ffmpeg/core/operations/ffmpeg_operation.dart';
import 'package:poc_ffmpeg/core/operations/filter_operation.dart';
import 'package:poc_ffmpeg/core/operations/trim_operation.dart';

class OperationFactory {
  static FFmpegOperation createTrimOperation(
      Duration startTime, Duration endTime) {
    return TrimOperation(TrimConfig(startTime: startTime, endTime: endTime));
  }

  static FFmpegOperation createFilterOperation(
      String filterName, String filterParams) {
    return FilterOperation(
        FilterConfig(filterName: filterName, filterParams: filterParams));
  }

  static FFmpegOperation createVideoFromImageOperation(
      List<String> imagesPath, String outputPath) {
    return CreateVideoFromImagesOperation(CreateVideoFromImagesConfig(
        imagePaths: imagesPath, outputFilePath: outputPath));
  }
}
