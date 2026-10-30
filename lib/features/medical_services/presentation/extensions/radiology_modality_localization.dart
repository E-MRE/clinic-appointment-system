import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';

/// Display labels for radiology imaging modalities.
extension RadiologyModalityLocalization on RadiologyModality {
  /// Localized name of this radiology modality.
  String get label => labelKey.translate();

  /// Localization key for this radiology modality.
  String get labelKey => switch (this) {
    RadiologyModality.xRay => LocaleKeys.services_radiologyModality_xRay,
    RadiologyModality.ultrasound =>
      LocaleKeys.services_radiologyModality_ultrasound,
    RadiologyModality.mri => LocaleKeys.services_radiologyModality_mri,
    RadiologyModality.ct => LocaleKeys.services_radiologyModality_ct,
  };
}
