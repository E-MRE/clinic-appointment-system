import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Landing page displaying medical services belonging to the selected branch.
final class MedicalServicesPage extends StatelessWidget {
  /// Creates the medical services landing page.
  const MedicalServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: PageHeader(title: LocaleKeys.services_title.tr()),
    );
  }
}
