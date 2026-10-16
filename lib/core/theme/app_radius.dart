import 'package:flutter/painting.dart';

/// Corner radius scale. Use these instead of inline `BorderRadius` values.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double full = 999;

  static const BorderRadius radiusSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius radiusMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius radiusLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius radiusFull = BorderRadius.all(
    Radius.circular(full),
  );

  static const BorderRadius button = radiusMd;
  static const BorderRadius card = radiusMd;
  static const BorderRadius input = radiusMd;
  static const BorderRadius dialog = radiusLg;
  static const BorderRadius chip = radiusFull;
}
