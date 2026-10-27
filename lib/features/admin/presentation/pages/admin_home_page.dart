import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/home_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Placeholder for the admin home.
final class AdminHomePage extends StatelessWidget {
  /// Creates the admin home placeholder.
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return HomePage(title: LocaleKeys.home_admin.tr());
  }
}
