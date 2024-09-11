import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:poc_ffmpeg/core/video-features/feature.dart';
import 'package:poc_ffmpeg/core/video-features/feature_factory.dart';
import 'package:poc_ffmpeg/core/video-features/feature_params.dart';
import 'package:poc_ffmpeg/core/video-features/text_feature.dart';
import 'package:poc_ffmpeg/utill/common_util.dart';
import 'package:poc_ffmpeg/utill/enums.dart';

class TextFeatureWidget extends StatefulWidget {
  final Function(Feature) callback;
  final Function(Feature) onClickCallback;
  final Feature? existingFeature;

  const TextFeatureWidget(
      {super.key,
      required this.callback,
      required this.onClickCallback,
      this.existingFeature});

  @override
  _TextFeatureWidgetState createState() => _TextFeatureWidgetState();
}

class _TextFeatureWidgetState extends State<TextFeatureWidget> {
  TextEditingController controller = TextEditingController();
  // create some values
  Color selectedColor = Color(0xFFFFFFFF);
  Color pickerColor = Color(0xff443a49);
  bool isBorderOn = false;
  List<TextAlign> alignments = [
    TextAlign.center,
    TextAlign.left,
    TextAlign.right,
    TextAlign.justify
  ];
  List<IconData> alignmentIcons = [
    Icons.format_align_center,
    Icons.format_align_left,
    Icons.format_align_right,
    Icons.format_align_justify
  ];
  int currentAlignmentIndex = 0;
  String? fontPath;

  void pickColor() {
    showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) {
              setState(() {
                pickerColor = color;
              });
            },
          ),
          // Use Material color picker:
          //
          // child: MaterialPicker(
          //   pickerColor: pickerColor,
          //   onColorChanged: changeColor,
          //   showLabel: true, // only on portrait mode
          // ),
          //
          // Use Block color picker:
          //
          // child: BlockPicker(
          //   pickerColor: currentColor,
          //   onColorChanged: changeColor,
          // ),
          //
          // child: MultipleChoiceBlockPicker(
          //   pickerColors: currentColors,
          //   onColorsChanged: changeColors,
          // ),
        ),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('Got it'),
            onPressed: () {
              setState(() => selectedColor = pickerColor);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    updateExistingFeatureData();
    getFontPath(true);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Text input form
        Align(
          alignment: Alignment.center,
          child: Form(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                textAlign: alignments[currentAlignmentIndex],
                controller: controller,
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w500,
                  color: selectedColor,
                ),
                decoration: InputDecoration(
                  hintText: 'Enter your text',
                  hintStyle: TextStyle(
                      color: Colors.grey[600], fontFamily: 'Montserrat'),
                  filled: true,
                  fillColor: Colors.black38,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: isBorderOn
                        ? const BorderSide(color: Colors.black)
                        : BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 68, 255, 90),
                      width: 2.0,
                    ),
                  ),
                ),
                onFieldSubmitted: (value) async {
                  widget.callback(FeatureFactory.createFeature(
                    TextParams(
                      id: widget.existingFeature?.id,
                      text: controller.text,
                      textStyle: TextStyle(
                          color: selectedColor,
                          fontSize: 24,
                          fontFamily: 'Montserrat'),
                      position: widget.existingFeature?.position ?? Offset(100, 100),
                      isFFmpegNeeded: true,
                      size: 0,
                      editingFeatures: VideoEditingFeatures.text,
                      fontPath: fontPath ?? await getFontPath(false),
                      onClickCallBack: widget.onClickCallback,
                    ),
                  )!);
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: 0,
          left: 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Text Color
                IconButton(
                  icon: Icon(Icons.color_lens, color: selectedColor),
                  onPressed: () {
                    pickColor();
                  },
                ),

                // Alignment
                IconButton(
                  icon: Icon(
                    alignmentIcons[currentAlignmentIndex],
                    color: Colors.white,
                  ),
                  onPressed: () {
                    int index;
                    if (currentAlignmentIndex == (alignments.length - 1)) {
                      index = 0;
                    } else {
                      index = currentAlignmentIndex + 1;
                    }
                    setState(() {
                      currentAlignmentIndex = index;
                    });
                  },
                ),

                // Border Toggle
                IconButton(
                  icon: Icon(Icons.border_outer,
                      color: isBorderOn ? Colors.blue : Colors.black),
                  onPressed: () {
                    setState(() {
                      isBorderOn = !isBorderOn;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<String> getFontPath(bool setValue) async {
    final font = await CommonUtil.getFontFilePath();
    if (setValue) {
      setState(() {
        fontPath = font;
      });
    }
    return font;
  }

  void updateExistingFeatureData() {
    if (widget.existingFeature != null) {
      final feature = widget.existingFeature as TextFeature;
      setState(() {
        selectedColor = feature.textStyle.color ?? Colors.white;
      });
      controller.text = feature.text;
    }
  }
}
