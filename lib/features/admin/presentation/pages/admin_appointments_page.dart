import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Placeholder header for the administrator's appointment destination.
final class AdminAppointmentsPage extends StatelessWidget {
  /// Creates the administrator appointment placeholder page.
  const AdminAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: PageHeader(
        title: LocaleKeys.admin_appointmentsTitle.tr(),
        subtitle: LocaleKeys.admin_appointmentsSubtitle.tr(),
      ),
    );
  }
}
