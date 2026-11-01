import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_button.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_fab.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_filter_chips.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/form_dialog/app_form_dialog.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel_layout.dart';
import 'package:clinic_appointment_system/core/widgets/state/app_muted_message.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_editor_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_filter_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/staff_list_overview_presentation.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/staff_overview_context.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/widgets/staff_form.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/staff_initials.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/user_role_staff_label.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
part 'staff_management_page_shell.dart';
part 'staff_management_header.dart';
part 'staff_management_add_button.dart';
part 'staff_management_branch_content.dart';
part 'staff_management_institution_button.dart';
part 'staff_management_no_branch.dart';
part 'staff_management_content.dart';
part 'staff_management_desktop_layout.dart';
part 'staff_management_desktop_panel_body.dart';
part 'staff_management_loaded.dart';
part 'staff_management_empty.dart';
part 'staff_management_filters.dart';
part 'staff_management_role_chips.dart';
part 'staff_management_department_select.dart';
part 'staff_management_mobile_view.dart';
part 'staff_management_mobile_list.dart';
part 'staff_management_mobile_card.dart';
part 'staff_management_name_cell.dart';
part 'staff_management_table.dart';
part 'staff_management_table_cell.dart';
part 'staff_management_filtered_empty.dart';
part 'staff_management_form_dialog.dart';
part 'staff_management_editor_navigation.dart';

/// Clinic-wide staff management with responsive list and editor surfaces.
final class StaffManagementPage extends StatelessWidget {
  /// Creates the staff management destination.
  const StaffManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final clinicId = InstitutionSelectionScope.of(context).clinicId;
    return MultiBlocProvider(
      key: ValueKey<String?>(clinicId),
      providers: [
        BlocProvider<StaffFilterCubit>(
          create: (_) => AppDependency.injector.get<StaffFilterCubit>(),
        ),
        BlocProvider<StaffEditorCubit>(
          create: (_) => AppDependency.injector.get<StaffEditorCubit>(),
        ),
      ],
      child: const _StaffManagementPageShell(),
    );
  }
}
