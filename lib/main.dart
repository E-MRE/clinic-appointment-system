import 'package:clinic_appointment_system/app.dart';
import 'package:clinic_appointment_system/app_initializer.dart';
import 'package:flutter/material.dart';

void main() async {
  await const AppInitializer().initialize();
  runApp(const App());
}
