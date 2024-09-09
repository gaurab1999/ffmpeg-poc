import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:poc_ffmpeg/core/utils/command_validator.dart';

class FFmpegExecutor {
  Future<void> executeCommand(String command) async {
    CommandValidator.validateCommand(command);
    await FFmpegKit.executeAsync(command);
  }
}
