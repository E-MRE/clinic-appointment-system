import 'package:clinic_appointment_system/core/constants/admin_layout_constants.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/extensions/date_time_weekday.dart';
import 'package:clinic_appointment_system/core/extensions/relative_time_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/progress_bar/app_progress_bar.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_appointment_action_context.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_status_filter_color.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/admin_status_filter_label.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_row_presentation.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_department_row.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_staff_row.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_summary.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_appointment_row_actions.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_metric_tone.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_metric_tone_colors.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/admin_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'admin_home_view.dart';
part 'admin_home_data_state.dart';
part 'admin_home_loaded_content.dart';
part 'admin_home_header.dart';
part 'admin_home_header_actions.dart';
part 'admin_home_metric_cards.dart';
part 'admin_home_metric_card.dart';
part 'admin_home_breakdown_cards.dart';
part 'admin_home_status_card.dart';
part 'admin_home_department_card.dart';
part 'admin_home_department_row.dart';
part 'admin_home_staff_card.dart';
part 'admin_home_staff_row.dart';
part 'admin_home_pending_table.dart';
part 'admin_home_pending_table_header.dart';
part 'admin_home_pending_empty.dart';
part 'admin_home_failure_state.dart';

/// Presents the administrator's daily appointment overview.
final class AdminHomePage extends StatefulWidget {
  /// Creates the administrator overview page.
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() {
    return _AdminHomePageState();
  }
}

final class _AdminHomePageState extends State<AdminHomePage> {
  late final Clock _clock;

  @override
  void initState() {
    super.initState();
    _clock = AppDependency.injector.get<Clock>();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      child: BlocProvider<AdminDashboardCubit>(
        create: (context) {
          final cubit = AppDependency.injector.get<AdminDashboardCubit>();
          final catalogState = context.read<ClinicCatalogCubit>().state;
          if (catalogState is ClinicCatalogLoaded) {
            cubit.updateCatalog(catalogState.catalog);
          }
          return cubit;
        },
        child: BlocListener<ClinicCatalogCubit, ClinicCatalogState>(
          listener: (context, state) {
            if (state is ClinicCatalogLoaded) {
              context.read<AdminDashboardCubit>().updateCatalog(state.catalog);
            }
          },
          child: _AdminHomeView(clock: _clock),
        ),
      ),
    );
  }
}
