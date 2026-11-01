import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_form_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/user_error_code_staff_localization.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/user_role_staff_form_strategy.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Feature-internal specialty field supplied by the doctor strategy.
final class StaffSpecialtyField extends StatelessWidget {
  /// Creates the doctor's specialty input.
  const StaffSpecialtyField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StaffFormCubit>();
    return AppTextField(
      label: LocaleKeys.staff_specialty.tr(),
      hint: LocaleKeys.staff_specialtyHint.tr(),
      initialValue: cubit.state.specialty,
      onChanged: cubit.changeSpecialty,
      validator: (value) {
        final values = cubit.state.copyWith(specialty: value ?? '');
        final preview = values.role.staffFormStrategy.build(
          values,
          id: EntityConstants.unsavedId,
        );
        return preview.detailsError?.staffMessage;
      },
    );
  }
}
