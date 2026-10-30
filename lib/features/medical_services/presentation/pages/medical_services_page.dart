import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_filter_chips.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_editor_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_filter_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/money_formatting.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/service_duration_formatting.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_list_overview.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_summary.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/visitors/medical_service_summary_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/widgets/medical_service_form.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'medical_services_add_button.dart';
part 'medical_services_branch_selector.dart';
part 'medical_services_cell_kind_icon.dart';
part 'medical_services_content.dart';
part 'medical_services_desktop_empty.dart';
part 'medical_services_desktop_layout.dart';
part 'medical_services_desktop_panel.dart';
part 'medical_services_desktop_panel_body.dart';
part 'medical_services_fab.dart';
part 'medical_services_filter_chips_row.dart';
part 'medical_services_filtered_empty.dart';
part 'medical_services_form_dialog.dart';
part 'medical_services_form_dialog_body.dart';
part 'medical_services_form_dialog_content.dart';
part 'medical_services_form_dialog_header.dart';
part 'medical_services_header.dart';
part 'medical_services_header_actions.dart';
part 'medical_services_loaded.dart';
part 'medical_services_mobile_card.dart';
part 'medical_services_mobile_card_details.dart';
part 'medical_services_mobile_card_row.dart';
part 'medical_services_mobile_list.dart';
part 'medical_services_mobile_view.dart';
part 'medical_services_no_branch.dart';
part 'medical_services_page_shell.dart';
part 'medical_services_service_cell.dart';
part 'medical_services_table.dart';
part 'medical_services_table_panel.dart';

/// Landing page displaying medical services belonging to the selected branch.
final class MedicalServicesPage extends StatelessWidget {
  /// Creates the medical services landing page.
  const MedicalServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MedicalServiceFilterCubit>(
          create: (_) =>
              AppDependency.injector.get<MedicalServiceFilterCubit>(),
        ),
        BlocProvider<MedicalServiceEditorCubit>(
          create: (_) =>
              AppDependency.injector.get<MedicalServiceEditorCubit>(),
        ),
      ],
      child: const _MedicalServicesPageShell(),
    );
  }
}
