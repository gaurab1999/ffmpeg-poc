import 'package:flutter/material.dart';

// Abstract class for common properties
abstract class Feature {
  Offset position;
  double size; // Represents the size (for scaling)

  Feature({
    required this.position,
    required this.size,
  });

  // Method to render the feature
  Widget render();
}
