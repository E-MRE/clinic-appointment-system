import 'package:clinic_appointment_system/core/constants/patient_layout_constants.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:clinic_appointment_system/core/widgets/dashed_border/app_dashed_border.dart';
import 'package:clinic_appointment_system/core/widgets/definition_row/app_definition_row.dart';
import 'package:clinic_appointment_system/core/widgets/icon_tile/app_icon_tile.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/state/app_muted_message.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_radius.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_variant.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/book_appointment_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/book_appointment_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/booking_selection_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/staff_week_schedule_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/staff_week_schedule_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/booking_cell_style.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/appointment_error_code_booking.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/booking_cell_style_colors.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/booking_selection_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/booking_service_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/booking_staff_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_catalog_views.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/staff_schedule_day_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/staff_slot_group_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/staff_slot_presentation.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/booking_selection.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_schedule_day.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot_group.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/user_display_name.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'patient_book_choice_cell.dart';
part 'patient_book_choice_column.dart';
part 'patient_book_content.dart';
part 'patient_book_day_cell.dart';
part 'patient_book_day_strip.dart';
part 'patient_book_department_chip.dart';
part 'patient_book_effects.dart';
part 'patient_book_failure.dart';
part 'patient_book_option_card.dart';
part 'patient_book_schedule_body.dart';
part 'patient_book_schedule_card.dart';
part 'patient_book_schedule_failure.dart';
part 'patient_book_schedule_header.dart';
part 'patient_book_search_field.dart';
part 'patient_book_section_title.dart';
part 'patient_book_service_card.dart';
part 'patient_book_service_section.dart';
part 'patient_book_slot_cell.dart';
part 'patient_book_slot_group.dart';
part 'patient_book_staff_card.dart';
part 'patient_book_staff_section.dart';
part 'patient_book_submit_area.dart';
part 'patient_book_submit_button.dart';
part 'patient_book_submit_progress.dart';
part 'patient_book_summary_card.dart';
part 'patient_book_summary_values.dart';
part 'patient_book_view.dart';
part 'patient_book_week_button.dart';
part 'patient_book_week_slots.dart';

/// The signed-in patient's booking page: choose a service, a staff member,
/// a day and a free slot, then request the appointment.
final class PatientBookPage extends StatelessWidget {
  /// Creates the booking page, optionally limited to a department.
  const PatientBookPage({this.departmentId, super.key});

  /// Department chosen on the appointments page, if any.
  final String? departmentId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    if (state is AuthSignedIn) {
      final user = state.user;
      return MultiBlocProvider(
        key: ValueKey<(String, String?)>((user.id, departmentId)),
        providers: [
          BlocProvider<BookingSelectionCubit>(
            create: (_) {
              return AppDependency.injector.get<BookingSelectionCubit>()
                ..limitToDepartment(departmentId);
            },
          ),
          BlocProvider<StaffWeekScheduleCubit>(
            create: (_) {
              return AppDependency.injector.get<StaffWeekScheduleCubit>();
            },
          ),
          BlocProvider<BookAppointmentCubit>(
            create: (_) {
              return AppDependency.injector.get<BookAppointmentCubit>();
            },
          ),
        ],
        child: _PatientBookView(
          patient: PatientAppointmentActor(id: user.id),
          patientName: user.fullName,
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
