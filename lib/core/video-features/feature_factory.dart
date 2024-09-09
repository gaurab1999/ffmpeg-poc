import 'package:poc_ffmpeg/core/video-features/add_yours_feature.dart';
import 'package:poc_ffmpeg/core/video-features/draw_feature.dart';
import 'package:poc_ffmpeg/core/video-features/feature.dart';
import 'package:poc_ffmpeg/core/video-features/feature_params.dart';
import 'package:poc_ffmpeg/core/video-features/link_challenge_feature.dart';
import 'package:poc_ffmpeg/core/video-features/quiz_feature.dart';
import 'package:poc_ffmpeg/core/video-features/text_feature.dart';
import 'package:poc_ffmpeg/utill/enums.dart';

class FeatureFactory {
  // This static method takes a FeatureParams object and creates the corresponding feature
  // based on the VideoEditingFeatures enum value. It returns a Feature object or null if
  // the feature is not supported or implemented.
  static Feature? createFeature(FeatureParams featureParams) {
    // Switch on the enum value to determine which feature to create
    switch (featureParams.editingFeatures) {
      // Handle 'Add Yours' feature creation
      case VideoEditingFeatures.addYours:
        // Cast featureParams to AddYoursParams for access to specific parameters
        AddYoursParams params = featureParams as AddYoursParams;
        // Create and return an AddYoursFeature using the parameters
        return AddYoursFeature(
            id: params.id,
            profileImageUrl: params.profileImageUrl,
            textController: params.textController,
            position: params.position,
            size: params.size,
            editingFeatures: params.editingFeatures,
            isFFmpegNeeded: params.isFFmpegNeeded,
            onClickCallBack: () {});

      // Handle 'Draw' feature creation
      case VideoEditingFeatures.draw:
        // Cast featureParams to DrawParams for access to specific parameters
        DrawParams params = featureParams as DrawParams;
        // Create and return a DrawFeature using the parameters
        return DrawFeature(
            id: params.id,
            points: params.points,
            color: params.color,
            strokeWidth: params.strokeWidth,
            position: params.position,
            size: params.size,
            editingFeatures: params.editingFeatures,
            isFFmpegNeeded: params.isFFmpegNeeded,
            onClickCallBack: () {});

      // Handle 'Text' feature creation
      case VideoEditingFeatures.text:
        // Cast featureParams to TextParams for access to specific parameters
        TextParams params = featureParams as TextParams;
        // Create and return a TextFeature using the parameters
        return TextFeature(
            id: params.id,
            text: params.text,
            textStyle: params.textStyle,
            position: params.position,
            size: params.size,
            editingFeatures: params.editingFeatures,
            isFFmpegNeeded: params.isFFmpegNeeded,
            fontPath: params.fontPath,
            onClickCallBack: params.onClickCallBack);

      // Handle 'Quiz/Poll' feature creation
      case VideoEditingFeatures.quizPoll:
        // Cast featureParams to QuizPollParams for access to specific parameters
        QuizPollParams params = featureParams as QuizPollParams;
        // Create and return a QuizPollFeature using the parameters
        return QuizPollFeature(
            id: params.id,
            question: params.question,
            options: params.options,
            selectedOption: params.selectedOption,
            position: params.position,
            size: params.size,
            editingFeatures: params.editingFeatures,
            isFFmpegNeeded: params.isFFmpegNeeded,
            onClickCallBack: () {});

      // Handle 'Link Challenge' feature creation
      case VideoEditingFeatures.linkChallenge:
        // Cast featureParams to LinkChallengeParams for access to specific parameters
        LinkChallengeParams params = featureParams as LinkChallengeParams;
        // Create and return a LinkChallengeFeature using the parameters
        return LinkChallengeFeature(
            id: params.id,
            challenges: params.challenges,
            position: params.position,
            size: params.size,
            editingFeatures: params.editingFeatures,
            isFFmpegNeeded: params.isFFmpegNeeded,
            onClickCallBack: () {});

      // Cases for unimplemented features like Boomerang, Template, and Audio
      case VideoEditingFeatures.boomerang:
        // Placeholder for future implementation
        break;
      case VideoEditingFeatures.template:
        // Placeholder for future implementation
        break;
      case VideoEditingFeatures.audio:
        // Placeholder for future implementation
        break;

      // Default case for unsupported feature types
      default:
        return null;
    }

    // Return null if no valid feature is created
    return null;
  }
}
