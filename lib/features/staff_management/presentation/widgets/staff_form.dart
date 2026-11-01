import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/checkbox_tile/app_checkbox_tile.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_segmented_control.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/auth/domain/mixins/auth_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/auth_error_code_localization.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/service_duration_formatting.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/mixins/staff_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_form_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_save_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_save_state.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/user_error_code_staff_localization.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/user_role_staff_form_strategy.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'staff_form_content.dart';
part 'staff_form_state_mixin.dart';
part 'staff_form_body.dart';
part 'staff_form_role_control.dart';
part 'staff_form_name_field.dart';
part 'staff_form_specialty_section.dart';
part 'staff_form_email_field.dart';
part 'staff_form_password_field.dart';
part 'staff_form_placement_fields.dart';
part 'staff_form_branch_field.dart';
part 'staff_form_department_field.dart';
part 'staff_form_services.dart';
part 'staff_form_services_heading.dart';
part 'staff_form_service_options.dart';
part 'staff_form_service_tile.dart';
part 'staff_form_password_help.dart';
part 'staff_form_actions.dart';
part 'staff_form_cancel_button.dart';
part 'staff_form_save_button.dart';
part 'staff_form_save_progress.dart';
part 'staff_form_save_error.dart';

/// Reusable staff account creation and profile editing form.
final class StaffForm extends StatelessWidget {
  /// Creates a form; supplying [staff] locks its account and placement fields.
  const StaffForm({this.staff, this.onCancel, this.onSaved, super.key});

  /// Existing profile to edit, or null to provision a new account.
  final Staff? staff;

  /// Optional action supplied by the hosting panel, dialog or page.
  final VoidCallback? onCancel;

  /// Invoked with the persisted profile after a successful save.
  final ValueChanged<Staff>? onSaved;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AppDependency.injector.get<StaffFormCubit>(),
        ),
        BlocProvider(
          create: (_) => AppDependency.injector.get<StaffSaveCubit>(),
        ),
        BlocProvider(
          create: (_) => AppDependency.injector.get<DepartmentListCubit>(),
        ),
        BlocProvider(
          create: (_) => AppDependency.injector.get<MedicalServiceListCubit>(),
        ),
      ],
      child: _StaffFormContent(
        staff: staff,
        onCancel: onCancel,
        onSaved: onSaved,
      ),
    );
  }
}
