import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:flutter/material.dart';

/// Placeholder for the patient's booking flow.
final class PatientBookPage extends StatelessWidget {
  /// Creates the booking placeholder, optionally preselecting a department.
  const PatientBookPage({this.departmentId, super.key});

  /// Department chosen on the appointments page, if any.
  final String? departmentId;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PageHeader(title: LocaleKeys.patient_book_title.translate()),
          Expanded(
            child: EmptyState(
              title: LocaleKeys.patient_book_comingSoonTitle.translate(),
              message: LocaleKeys.patient_book_comingSoonMessage.translate(),
              icon: Icon(
                Icons.edit_calendar_outlined,
                color: context.colorScheme.onSecondaryContainer,
              ),
              iconBackground: context.colorScheme.secondaryContainer,
            ),
          ),
        ],
      ),
    );
  }
}
