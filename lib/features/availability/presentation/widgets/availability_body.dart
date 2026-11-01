import 'package:clinic_appointment_system/core/constants/availability_constants.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_button.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_bottom_sheet_presentation.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_sheet_actions.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_segmented_control.dart';
import 'package:clinic_appointment_system/core/widgets/dashed_border/app_dashed_border.dart';
import 'package:clinic_appointment_system/core/widgets/date_field/app_date_field.dart';
import 'package:clinic_appointment_system/core/widgets/form_dialog/app_form_dialog.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel_layout.dart';
import 'package:clinic_appointment_system/core/widgets/state/app_muted_message.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_radius.dart';
import 'package:clinic_appointment_system/core/widgets/time_field/app_time_field.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_branch_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_add_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_draft_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_remove_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_save_state.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/staff_availability_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/staff_service_durations_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_repeat.dart';
import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_timeline_bar_variant.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_branch_presentation.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_draft_presentation.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_error_code_localization.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_minutes_label.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_timeline_bar_variant_colors.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/time_error_code_availability_localization.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_preview.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_timeline.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/timeline_segment.dart';
import 'package:clinic_appointment_system/features/availability/presentation/visitors/availability_window_label_visitor.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'availability_body_add_button.dart';
part 'availability_body_branch_banner.dart';
part 'availability_body_branch_caption.dart';
part 'availability_body_content.dart';
part 'availability_body_date_select.dart';
part 'availability_body_day_add_button.dart';
part 'availability_body_day_content.dart';
part 'availability_body_day_row.dart';
part 'availability_body_day_windows.dart';
part 'availability_body_desktop_layout.dart';
part 'availability_body_desktop_viewport.dart';
part 'availability_body_dialog_actions.dart';
part 'availability_body_editor_presentation.dart';
part 'availability_body_failure.dart';
part 'availability_body_form_error.dart';
part 'availability_body_form_helper.dart';
part 'availability_body_frame.dart';
part 'availability_body_header.dart';
part 'availability_body_mobile_layout.dart';
part 'availability_body_modal_scope.dart';
part 'availability_body_one_off_add_button.dart';
part 'availability_body_one_off_icon.dart';
part 'availability_body_one_off_identity.dart';
part 'availability_body_one_off_item.dart';
part 'availability_body_one_off_section.dart';
part 'availability_body_range_chip.dart';
part 'availability_body_repeat_control.dart';
part 'availability_body_save_button.dart';
part 'availability_body_sheet_actions.dart';
part 'availability_body_tablet_layout.dart';
part 'availability_body_time_fields.dart';
part 'availability_body_timeline.dart';
part 'availability_body_timeline_background.dart';
part 'availability_body_timeline_bar.dart';
part 'availability_body_timeline_bar_outline.dart';
part 'availability_body_timeline_day_label.dart';
part 'availability_body_timeline_edit_button.dart';
part 'availability_body_timeline_footnote.dart';
part 'availability_body_timeline_opening.dart';
part 'availability_body_timeline_positioned_bar.dart';
part 'availability_body_timeline_row.dart';
part 'availability_body_timeline_ticks.dart';
part 'availability_body_timeline_track.dart';
part 'availability_body_weekday_select.dart';
part 'availability_body_weekly_card.dart';
part 'availability_body_weekly_heading.dart';
part 'availability_body_window_dialog.dart';
part 'availability_body_window_form.dart';
part 'availability_body_window_panel.dart';
part 'availability_body_window_preview.dart';
part 'availability_body_window_save_scope.dart';
part 'availability_body_window_sheet.dart';

/// Reusable availability scope and content for staff and administrator shells.
final class AvailabilityBody extends StatelessWidget {
  /// Creates a staff-owned scope and builds [header] inside its providers.
  const AvailabilityBody({
    required this.staff,
    required this.header,
    super.key,
  });

  /// The staff member whose schedule is observed and edited.
  final Staff staff;

  /// Shell-specific heading with access to this body's cubits.
  final Widget header;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Staff>.value(value: staff),
        RepositoryProvider<AvailabilitySubject>.value(
          value: AvailabilitySubject.ofStaff(staff),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<StaffAvailabilityCubit>(
            lazy: false,
            create: (_) =>
                AppDependency.injector.get<StaffAvailabilityCubit>()
                  ..watch(AvailabilitySubject.ofStaff(staff)),
          ),
          BlocProvider<AvailabilityBranchCubit>(
            lazy: false,
            create: (_) =>
                AppDependency.injector.get<AvailabilityBranchCubit>()
                  ..watch(staff.branchId),
          ),
          BlocProvider<StaffServiceDurationsCubit>(
            lazy: false,
            create: (_) =>
                AppDependency.injector.get<StaffServiceDurationsCubit>()
                  ..watch(staff),
          ),
          BlocProvider<AvailabilityWindowDraftCubit>(
            create: (_) =>
                AppDependency.injector.get<AvailabilityWindowDraftCubit>(),
          ),
          BlocProvider<AvailabilityWindowRemoveCubit>(
            create: (_) =>
                AppDependency.injector.get<AvailabilityWindowRemoveCubit>(),
          ),
          BlocProvider<AvailabilityWindowAddCubit>(
            create: (_) =>
                AppDependency.injector.get<AvailabilityWindowAddCubit>(),
          ),
        ],
        child: _AvailabilityBodyFrame(header: header),
      ),
    );
  }
}
