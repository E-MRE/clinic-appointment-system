import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/working_hours_summary.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/department_section.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_branch_card.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_counts.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/institution_list_view.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/working_hours_section.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

part 'clinic_name_dialog_content.dart';
part 'clinic_name_dialog_actions.dart';
part 'clinic_name_save_button.dart';
part 'institution_branches.dart';
part 'institution_branch_list.dart';
part 'institution_branch_item.dart';
part 'institution_branch_details.dart';
part 'institution_content.dart';
part 'institution_clinic_header.dart';
part 'institution_clinic_picker.dart';
part 'institution_new_clinic_button.dart';
part 'institution_branch_header.dart';
part 'institution_content_branches.dart';
part 'institution_mobile_add_branch.dart';
part 'institution_page_content.dart';
part 'clinic_name_dialog.dart';

/// Administrator institution overview and responsive branch selection.
final class InstitutionPage extends StatelessWidget {
  const InstitutionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(child: _InstitutionPageContent());
  }
}
