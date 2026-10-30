import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/mixins/medical_service_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_form_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/lab_result_time_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lab_test_details_row.dart';
part 'lab_test_fasting_hours_field.dart';
part 'lab_test_fasting_toggle_row.dart';
part 'lab_test_result_time_field.dart';

/// Form section presenting laboratory fasting toggles, fasting hour inputs and result duration.
final class LabTestFormSection extends StatelessWidget
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin {
  /// Creates the lab test configuration section.
  const LabTestFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s12,
        children: [
          AppText.badge(
            LocaleKeys.services_labSpecial.tr(),
            tone: TextTone.muted,
            fontWeight: FontWeight.w600,
          ),
          const _LabTestFastingToggleRow(),
          const _LabTestDetailsRow(),
        ],
      ),
    );
  }
}
