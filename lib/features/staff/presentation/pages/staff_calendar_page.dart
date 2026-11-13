import 'dart:async';

import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_segmented_control.dart';
import 'package:clinic_appointment_system/core/widgets/dashed_border/app_dashed_border.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_appointments_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_calendar_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_workspace_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_calendar_view.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/appointment_status_calendar_tone.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_appointment_presentation.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_calendar_header_title.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_day.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout_factory.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_appointment_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staff_calendar_appointment_block.dart';
part 'staff_calendar_body.dart';
part 'staff_calendar_day_column.dart';
part 'staff_calendar_failure.dart';
part 'staff_calendar_grid.dart';
part 'staff_calendar_grid_header.dart';
part 'staff_calendar_header.dart';
part 'staff_calendar_header_actions.dart';
part 'staff_calendar_hour_column.dart';
part 'staff_calendar_legend.dart';
part 'staff_calendar_legend_item.dart';
part 'staff_calendar_now_line.dart';
part 'staff_calendar_scope.dart';
part 'staff_calendar_view_content.dart';

/// The doctor and technician calendar page with day/week navigation and grid.
final class StaffCalendarPage extends StatelessWidget {
  /// Creates the staff calendar page with an optional appointment tap hook.
  const StaffCalendarPage({this.onAppointmentTap, super.key});

  /// Replaces the default tap behavior (opening the staff appointment
  /// dialog) when set; used by tests and embedding pages.
  final ValueChanged<Appointment>? onAppointmentTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StaffCalendarCubit>(
      create: (_) => AppDependency.injector.get<StaffCalendarCubit>(),
      child: _StaffCalendarScope(
        onAppointmentTap: onAppointmentTap,
        child: const _StaffCalendarViewContent(),
      ),
    );
  }
}
