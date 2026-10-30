import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_segmented_control.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/mixins/medical_service_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_form_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_save_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_form_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/visitors/medical_service_form_values_visitor.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'medical_service_form_actions.dart';
part 'medical_service_form_body.dart';
part 'medical_service_form_cancel_button.dart';
part 'medical_service_form_save_button.dart';
part 'medical_service_form_save_progress.dart';
part 'medical_service_form_department_field.dart';
part 'medical_service_form_duration_fee_row.dart';
part 'medical_service_form_kind_control.dart';
part 'medical_service_form_kind_section.dart';
part 'medical_service_form_name_field.dart';
part 'medical_service_form_save_error.dart';
part 'medical_service_form_state_mixin.dart';

/// Form body for configuring and persisting medical service records.
final class MedicalServiceForm extends StatefulWidget {
  /// Creates the medical service form.
  const MedicalServiceForm({
    required this.onSaved,
    this.service,
    this.branchId,
    this.onCancel,
    super.key,
  });

  /// The medical service being edited, or null for creation.
  final MedicalService? service;

  /// Identifier of the branch hosting this service.
  final String? branchId;

  /// Callback invoked after successfully persisting the service.
  final ValueChanged<MedicalService> onSaved;

  /// Optional callback invoked when the user cancels the form.
  final VoidCallback? onCancel;

  /// Whether the form is editing an existing service.
  bool get isEditing => service != null;

  @override
  State<MedicalServiceForm> createState() => _MedicalServiceFormState();
}

final class _MedicalServiceFormState extends State<MedicalServiceForm>
    with _MedicalServiceFormStateMixin {
  late final GlobalKey<FormState> _formKey;
  late final MedicalServiceFormCubit _formCubit;
  late final MedicalServiceSaveCubit _saveCubit;

  @override
  GlobalKey<FormState> get formKey => _formKey;

  @override
  MedicalServiceFormCubit get formCubit => _formCubit;

  @override
  MedicalServiceSaveCubit get saveCubit => _saveCubit;

  @override
  void initState() {
    super.initState();
    _formKey = GlobalKey<FormState>();
    final initialValues =
        widget.service?.accept(const MedicalServiceFormValuesVisitor()) ??
        const MedicalServiceFormValues.empty();
    _formCubit = AppDependency.injector.get<MedicalServiceFormCubit>()
      ..initialize(initialValues);
    _saveCubit = AppDependency.injector.get<MedicalServiceSaveCubit>();
  }

  @override
  void dispose() {
    _formCubit.close();
    _saveCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MedicalServiceFormCubit>.value(value: _formCubit),
        BlocProvider<MedicalServiceSaveCubit>.value(value: _saveCubit),
      ],
      child:
          BlocListener<
            MedicalServiceSaveCubit,
            InstitutionSaveState<MedicalService>
          >(
            listener: onSaveState,
            child: _MedicalServiceFormBody(
              formKey: _formKey,
              isEditing: widget.isEditing,
              onSave: submit,
              onCancel: widget.onCancel,
            ),
          ),
    );
  }
}
