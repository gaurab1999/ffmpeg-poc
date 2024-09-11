import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/video-features/feature.dart';
import 'package:poc_ffmpeg/utill/common_util.dart';
import 'package:poc_ffmpeg/utill/enums.dart';

class TextFeature extends Feature {
  final String text;
  final TextStyle textStyle;
  final String fontPath;

  TextFeature(
      {required this.text,
      required this.textStyle,
      required super.position,
      required super.size,
      required super.editingFeatures,
      required super.isFFmpegNeeded,
      required this.fontPath,
      required super.onClickCallBack,
      super.id
      });

  TextFeature copyWith({
    String? text,
    TextStyle? textStyle,
    Offset? position,
    double? size,
    bool? isFFmpegNeeded,
    String? fontPath,
    Function()? onClickCallBack,
    String? id,
    VideoEditingFeatures? editingFeatures
  }) {
    return TextFeature(
      text: text ?? this.text,
      textStyle: textStyle ?? this.textStyle,
      position: position ?? this.position,
      size: size ?? this.size,
      isFFmpegNeeded: isFFmpegNeeded ?? this.isFFmpegNeeded,
      fontPath: fontPath ?? this.fontPath,
      onClickCallBack: onClickCallBack ?? this.onClickCallBack,
      id: id ?? this.id, 
      editingFeatures: editingFeatures ?? this.editingFeatures,
    );
  }    

  @override
  Widget render() {
    return GestureDetector(
      onTap: () {
        onClickCallBack(this);
      },
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }

  @override
  String generateFFmpegCommand() {    
    final color =
        textStyle.color?.toHex() ?? 'white'; // Default to white if not set

    // Construct drawtext command for TextFeature
    return "drawtext=text='$text':x=${position.dx}:y=${position.dy}:fontsize=$size:fontcolor=$color:fontfile=$fontPath";
  }
}
