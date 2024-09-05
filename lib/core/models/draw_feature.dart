import 'package:flutter/material.dart';
import 'package:poc_ffmpeg/core/models/feature.dart';

class DrawFeature extends Feature {
  List<Offset> points;
  Color color;
  double strokeWidth;

  DrawFeature({
    required this.points,
    required this.color,
    required this.strokeWidth,
    required super.position,
    required super.size,
  });

  @override
  Widget render() {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: CustomPaint(
        size: Size(300 * size, 300 * size), // Use the size to scale
        painter: DrawPainter(points, color, strokeWidth),
      ),
    );
  }
}

// Custom Painter for drawing
class DrawPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  DrawPainter(this.points, this.color, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
