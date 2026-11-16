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
part 'working_hours_editor_range.dart';

/// Seven-day editor with split ranges and domain-backed inline errors.
final class WorkingHoursEditor extends StatelessWidget {
  const WorkingHoursEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context),
          const EmptySize.s12Height(),
          _buildDays(),
        ],
      ),
    );
  }

  /// Builds the working-hours heading and copy action.
  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText.sectionTitle(LocaleKeys.institution_workingHours.tr()),
        ),
        TextButton(
          onPressed: () => context
              .read<WorkingHoursEditorCubit>()
              .copyToWeekdays(Weekday.monday),
          child: AppText.label(LocaleKeys.institution_copyToWeekdays.tr()),
        ),
      ],
    );
  }

  /// Rebuilds the seven day rows when the editor changes.
  Widget _buildDays() {
    return BlocBuilder<WorkingHoursEditorCubit, WorkingHoursEditorState>(
      builder: (context, state) {
        return Column(
          children: [
            for (final day in Weekday.values) _WorkingHoursEditorDay(day: day),
          ],
        );
      },
    );
  }
}
