import 'dart:developer';


import 'package:ffmpeg_kit_flutter_full_gpl/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_full_gpl/return_code.dart';
import 'package:poc_ffmpeg/core/operations/ffmpeg_operation.dart';


class MediaProcessor {
  final List<FFmpegOperation> operations = [];

  void addOperation(FFmpegOperation operation) {
    operations.add(operation);
  }

  String buildCommand(String inputPath, String outputPath) {
    final command = operations.map((op) => op.generateCommand()).join(' ');
    // Use escaped double quotes within the string
    return '-i "$inputPath" $command "$outputPath"';
  }

  String buildCommandInBatches() {
    final List<String> commands = [];
    const int batchSize = 10; // Adjust batch size as needed

    for (int i = 0; i < operations.length; i += batchSize) {
      final batch = operations
          .skip(i)
          .take(batchSize)
          .map((op) => op.generateCommand())
          .join(' ');
      commands.add(batch);
    }

    return commands.join(' ');
  }

  Future<void> execute(String command) async {
    // final command = buildCommand(inputPath, outputPath);
    // final command = buildCommandInBatches();

    // Execute the FFmpeg command
    final session = await FFmpegKit.execute(command);

    final sessionId = session.getSessionId();
    final commandStr = session.getCommand();
    final commandArguments = session.getArguments();
    final state = await session.getState();
    final returnCode = await session.getReturnCode();
    final startTime = session.getStartTime();
    final endTime = await session.getEndTime();
    final duration = await session.getDuration();
    final output = await session.getOutput();
    final failStackTrace = await session.getFailStackTrace();
    final logs = await session.getLogs();

    log('Session ID: $sessionId');
    log('Command: $commandStr');
    log('Arguments: $commandArguments');
    log('State: $state');
    log('Return Code: $returnCode');
    log('Start Time: $startTime');
    log('End Time: $endTime');
    log('Duration: $duration');
    log('Output: $output');
    log('Fail Stack Trace: $failStackTrace');
    log('Logs:');
    for (var ffmpegLog in logs) {
      log(ffmpegLog.getMessage());
    }

    if (ReturnCode.isSuccess(returnCode)) {
      log("FFmpeg command success");
    } else if (ReturnCode.isCancel(returnCode)) {
      throw Exception('FFmpeg command cancel with return code: $returnCode');
    } else {
      throw Exception('FFmpeg command failed with return code: $returnCode');
    }
  }
}
