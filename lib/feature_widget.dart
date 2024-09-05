import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/models/feature.dart';

class FeatureWidget extends StatefulWidget {
  final Feature feature;
  final void Function(Feature feature) onUpdateFeature;

  const FeatureWidget(
      {super.key, required this.feature, required this.onUpdateFeature});

  @override
  _FeatureWidgetState createState() => _FeatureWidgetState();
}

class _FeatureWidgetState extends State<FeatureWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.feature.position.dx,
      top: widget.feature.position.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            widget.feature.position = Offset(
                widget.feature.position.dx + details.delta.dx,
                widget.feature.position.dy + details.delta.dy);
          });
          widget.onUpdateFeature(widget.feature);
        },
        child: widget.feature.render(),
      ),
    );
  }
}
