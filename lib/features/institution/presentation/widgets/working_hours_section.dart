import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/weekday_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Read-only branch hours used by both detail and inline panels.
final class WorkingHoursSection extends StatelessWidget {
  const WorkingHoursSection({
    required this.hours,
    required this.onEdit,
    super.key,
  });

  final WorkingHours hours;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.sectionTitle(
                  LocaleKeys.institution_workingHours.tr(),
                ),
              ),
              TextButton(
                onPressed: onEdit,
                child: AppText.label(
                  LocaleKeys.institution_editWorkingHours.tr(),
                ),
              ),
            ],
          ),
          const EmptySize.s12Height(),
          for (final day in Weekday.values)
            AppListTile(title: day.label, subtitle: _ranges(day)),
        ],
      ),
    );
  }

  String _ranges(Weekday day) {
    final ranges = hours.rangesOn(day);
    if (ranges.isEmpty) return LocaleKeys.institution_closed.tr();
    return ranges.map((range) => '${range.start}–${range.end}').join(' · ');
  }
}
