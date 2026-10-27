import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Placeholder for the patient home.
final class PatientHomePage extends StatelessWidget {
  /// Creates the patient home placeholder.
  const PatientHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(title: LocaleKeys.home_patient.tr());
  }
}
