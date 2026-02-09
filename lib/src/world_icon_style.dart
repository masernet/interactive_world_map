import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class WorldIconStyle {
  const WorldIconStyle({
    this.fillColor = const Color(0xFFE6E6E6),
    this.borderColor = const Color(0xFF999999),
    this.borderWidth = 1.0,
    this.showBorders = true,
    this.outlineOnly = false,
  });

  final Color fillColor;
  final Color borderColor;
  final double borderWidth;
  final bool showBorders;
  final bool outlineOnly;
}
