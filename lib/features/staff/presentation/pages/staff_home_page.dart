import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Placeholder for the staff home.
final class StaffHomePage extends StatelessWidget {
  /// Creates the staff home placeholder.
  const StaffHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(title: LocaleKeys.home_staff.tr());
  }
}
