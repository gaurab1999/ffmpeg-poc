import 'package:flutter/material.dart';

class DrawFeatureWidget extends StatefulWidget {
  final Function(double) onChanged;

  const DrawFeatureWidget({Key? key, required this.onChanged}) : super(key: key);

  @override
  _DrawFeatureWidgetState createState() => _DrawFeatureWidgetState();
}

class _DrawFeatureWidgetState extends State<DrawFeatureWidget> {
  double sliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Slider Feature"),
        Slider(
          value: sliderValue,
          min: 0,
          max: 100,
          divisions: 10,
          onChanged: (value) {
            setState(() {
              sliderValue = value;
            });
            widget.onChanged(value);
          },
        ),
      ],
    );
  }
}
