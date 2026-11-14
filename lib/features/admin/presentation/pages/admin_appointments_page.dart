import 'package:clinic_appointment_system/core/constants/admin_appointment_constants.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_filter_chips.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/core/widgets/time_field/app_picker_field.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_appointment_action_context.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_status_filter_label.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_row_presentation.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_appointment_row_actions.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/admin_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_status_badge.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_appointments_view.dart';
part 'admin_appointments_data_state.dart';
part 'admin_appointments_loaded_content.dart';
part 'admin_appointments_filter_card.dart';
part 'admin_appointments_filter_fields.dart';
part 'admin_appointments_filter_statuses.dart';
part 'admin_appointments_date_range_field.dart';
part 'admin_appointments_table.dart';
part 'admin_appointments_table_header.dart';
part 'admin_appointments_table_footer.dart';
part 'admin_appointments_empty_state.dart';

/// Lists, filters and manages the administrator's appointments.
final class AdminAppointmentsPage extends StatefulWidget {
  /// Creates the routed administrator appointment page.
  const AdminAppointmentsPage({super.key});

  @override
  State<AdminAppointmentsPage> createState() => _AdminAppointmentsPageState();
}

final class _AdminAppointmentsPageState extends State<AdminAppointmentsPage> {
  late final Clock _clock;
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _clock = AppDependency.injector.get<Clock>();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BlocProvider<AdminAppointmentsCubit>(
        create: (_) => AppDependency.injector.get<AdminAppointmentsCubit>(),
        child: _AdminAppointmentsView(
          clock: _clock,
          searchController: _searchController,
          onClearFilters: _clearFilters,
        ),
      ),
    );
  }

  void _clearFilters(BuildContext context) {
    _searchController.clear();
    context.read<AdminAppointmentsCubit>().clearFilters();
  }
}
