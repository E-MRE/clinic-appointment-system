import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/extensions/clock_time_picking.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'working_hours_editor_day.dart';
part 'working_hours_editor_day_header.dart';
part 'working_hours_editor_day_ranges.dart';
part 'working_hours_editor_days.dart';
part 'working_hours_editor_header.dart';
part 'working_hours_editor_range.dart';
part 'working_hours_editor_range_remove.dart';

/// Seven-day editor with split ranges and domain-backed inline errors.
final class WorkingHoursEditor extends StatelessWidget {
  const WorkingHoursEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WorkingHoursEditorHeader(),
          EmptySize.s12Height(),
          _WorkingHoursEditorDays(),
        ],
      ),
    );
  }
}
