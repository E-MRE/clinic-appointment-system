import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

Widget widgetTestHost(
  Widget child, {
  Brightness brightness = Brightness.light,
  Size size = const Size(390, 844),
  double textScale = 1,
}) {
  final screenSize = BreakpointsConstants.resolve(size.width, size.height);
  final theme = brightness == Brightness.light
      ? LightTheme(screenSize).themeData
      : DarkTheme(screenSize).themeData;
  return MaterialApp(
    theme: theme,
    home: MediaQuery(
      data: MediaQueryData(
        size: size,
        textScaler: TextScaler.linear(textScale),
      ),
      child: Scaffold(body: child),
    ),
  );
}
