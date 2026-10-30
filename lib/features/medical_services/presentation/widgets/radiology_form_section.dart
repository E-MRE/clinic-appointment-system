import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_filter_chips.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/presentation/extensions/institution_error_code_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/mixins/medical_service_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_form_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/radiology_modality_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'radiology_modality_chips.dart';
part 'radiology_preparation_note_field.dart';

/// Form section presenting radiology imaging modality chips and patient preparation notes.
final class RadiologyFormSection extends StatelessWidget
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin {
  /// Creates the radiology configuration section.
  const RadiologyFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.compact,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s12,
        children: [
          AppText.badge(
            LocaleKeys.services_radiologySpecial.tr(),
            tone: TextTone.muted,
            fontWeight: FontWeight.w600,
          ),
          const _RadiologyModalityChips(),
          const _RadiologyPreparationNoteField(),
        ],
      ),
    );
  }
}
