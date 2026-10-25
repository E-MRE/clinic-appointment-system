import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Keeps the system status/navigation bar icons readable on [background].
final class SystemOverlayRegion extends StatelessWidget {
  const SystemOverlayRegion({
    required this.background,
    required this.child,
    super.key,
  });

  final Color background;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: _overlayStyleFor(background),
    child: child,
  );

  /// Light icons on dark backgrounds, dark icons on light ones.
  SystemUiOverlayStyle _overlayStyleFor(Color background) =>
      ThemeData.estimateBrightnessForColor(background) == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
}
