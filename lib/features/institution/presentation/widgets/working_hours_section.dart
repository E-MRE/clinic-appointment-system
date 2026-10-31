import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/working_hours_range_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

part 'working_hours_section_header.dart';

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
          _WorkingHoursSectionHeader(onEdit: onEdit),
          const EmptySize.s12Height(),
          for (final day in Weekday.values)
            AppListTile(title: day.label, subtitle: hours.rangeLabel(day)),
        ],
      ),
    );
  }
}
