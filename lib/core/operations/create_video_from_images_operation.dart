import 'package:poc_ffmpeg/core/models/operation_model.dart';
import 'package:poc_ffmpeg/core/operations/ffmpeg_operation.dart';

class CreateVideoFromImagesOperation implements FFmpegOperation {
  final CreateVideoFromImagesConfig config;

  CreateVideoFromImagesOperation(this.config);

  @override
  String generateCommand() {
    final List<String> filters = [
      '[0]fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v0]',
      '[1]fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v1]',
      '[2]fade=t=in:st=0:d=1,fade=t=out:st=4:d=1[v2]'
    ];

    const int duration = 5;
    const int fadeDuration = 1;

    for (int i = 0; i < config.imagePaths.length; i++) {
      // Add input for each image
      config.imagePaths.add('-loop 1 -t $duration -i ${config.imagePaths[i]}');

      // Add filter for fade in and fade out
      filters.add(
          '[$i]fade=t=in:st=0:d=$fadeDuration,fade=t=out:st=${duration - fadeDuration}:d=$fadeDuration[v$i]');
    }

    // Concatenate all filters
    final String filterComplex = filters.join('; ');
    final String concatFilter =
        '[${List.generate(config.imagePaths.length, (index) => 'v$index').join('][')}]concat=n=${config.imagePaths.length}:v=1:a=0,format=yuv420p[v]';

    // Combine all parts into the final FFmpeg command
    final String ffmpegCommand = '''
      ${config.imagePaths.join(' ')} -filter_complex "$filterComplex; $concatFilter" -map "[v]" -threads 4 -y ${config.outputFilePath}
    ''';

    return ffmpegCommand.trim();
  }
}
