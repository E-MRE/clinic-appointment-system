import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Institution-specific text and icon for the shared empty state.
final class InstitutionNotFound extends StatelessWidget {
  const InstitutionNotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: LocaleKeys.institution_notFound.tr(),
      message: LocaleKeys.institution_notFoundDescription.tr(),
      icon: const Icon(Icons.search_off),
      iconBackground: context.colorScheme.surfaceContainerHighest,
    );
  }
}
