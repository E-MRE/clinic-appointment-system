import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Form page for creating or editing a medical service.
final class MedicalServiceFormPage extends StatelessWidget {
  /// Creates the medical service editor placeholder.
  const MedicalServiceFormPage({this.serviceId, super.key});

  /// The identifier of the service being edited, or null for creation.
  final String? serviceId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: PageHeader(title: LocaleKeys.services_title.tr()),
    );
  }
}
