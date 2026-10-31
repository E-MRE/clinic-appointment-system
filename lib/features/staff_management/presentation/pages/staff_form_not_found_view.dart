import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Empty state scaffold displayed when the requested staff profile cannot be found.
final class StaffFormNotFoundView extends StatelessWidget {
  const StaffFormNotFoundView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: EmptyState(
        title: LocaleKeys.staff_notFoundTitle.tr(),
        message: LocaleKeys.staff_notFoundMessage.tr(),
        icon: const Icon(Icons.search_off),
        iconBackground: context.colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
