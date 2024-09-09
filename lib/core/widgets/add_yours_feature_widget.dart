import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/video-features/feature.dart';
import 'package:poc_ffmpeg/core/video-features/feature_factory.dart';
import 'package:poc_ffmpeg/core/video-features/feature_params.dart';
import 'package:poc_ffmpeg/utill/enums.dart';

class AddYoursFeatureWidget extends StatefulWidget {
  final Function(Feature) callback;

  const AddYoursFeatureWidget({super.key, required this.callback});

  @override
  _AddYoursFeatureWidgetState createState() => _AddYoursFeatureWidgetState();
}

class _AddYoursFeatureWidgetState extends State<AddYoursFeatureWidget> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: controller,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
          decoration: InputDecoration(
            hintText: 'Enter your text',
            hintStyle: TextStyle(color: Colors.grey[600]),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: Colors.blueAccent,
                width: 2.0,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            prefixIcon: const Icon(
              Icons.text_fields,
              color: Colors.blueAccent,
            ),
          ),
          onFieldSubmitted: (value) {
            widget.callback(FeatureFactory.createFeature(AddYoursParams(
              onClickCallBack: (){},
                profileImageUrl: '',
                textController: controller,
                position: const Offset(0, 0),
                size: 0,
                isFFmpegNeeded: false,
                editingFeatures: VideoEditingFeatures.addYours))!);            
          },
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.camera),
              SizedBox(width: 8),
              Text("Add Yours"),
            ],
          ),
        ),
      ],
    );
  }
}
