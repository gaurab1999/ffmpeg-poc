class TrimConfig {
  final Duration startTime;
  final Duration endTime;

  TrimConfig({required this.startTime, required this.endTime});
}

class FilterConfig {
  final String filterName;
  final String filterParams;

  FilterConfig({required this.filterName, required this.filterParams});
}

class CreateVideoFromImagesConfig {
  final List<String> imagePaths;
  final String outputFilePath;

  CreateVideoFromImagesConfig(
      {required this.imagePaths, required this.outputFilePath});
}

class AddAudioToVideoConfig {
  final List videoPath;
  final String audioPath;

  AddAudioToVideoConfig({required this.videoPath, required this.audioPath});
}
