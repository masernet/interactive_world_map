import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum BorderWidthMode {
  /// Border bleibt optisch ungefähr gleich dick (Screen Space).
  /// Technisch: strokeWidth = desiredPx / currentScale
  screenSpace,

  /// Border zoomt mit (Map Space).
  /// Technisch: strokeWidth = desiredMapUnits
  mapSpace,
}

@immutable
class WorldMapStyle {
  const WorldMapStyle({
    this.landFillColor = const Color(0xFFE6E6E6),
    this.highlightedFillColor = const Color(0xFF7FB3FF),
    this.selectedFillColor = const Color(0xFF4F8EF7),
    this.showBorders = true,
    this.borderColor = const Color(0xFF999999),
    this.borderWidth = 0.6,
    this.borderWidthMode = BorderWidthMode.screenSpace,
    this.minBorderWidth = 0.2,
    this.maxBorderWidth = 2.0,
    this.borderWidthBuilder,
  });

  final Color landFillColor;
  final Color highlightedFillColor;
  final Color selectedFillColor;

  final bool showBorders;
  final Color borderColor;

  /// Basis-Breite. Interpretation hängt von [borderWidthMode] ab.
  final double borderWidth;

  final BorderWidthMode borderWidthMode;

  /// Clamp der finalen strokeWidth (in Map Space, also das was Paint.strokeWidth bekommt)
  final double minBorderWidth;
  final double maxBorderWidth;

  /// Optional: volle Kontrolle. Rückgabe = strokeWidth (Map Space).
  /// Beispiel: (scale) => 1.0 / scale  (Screen-constant)
  final double Function(double scale)? borderWidthBuilder;

  double strokeWidthForScale(double scale) {
    final w = borderWidthBuilder != null
        ? borderWidthBuilder!(scale)
        : (borderWidthMode == BorderWidthMode.screenSpace
            ? (borderWidth / scale)
            : borderWidth);

    final clamped = w.clamp(minBorderWidth, maxBorderWidth);
    return clamped.toDouble();
  }
}
