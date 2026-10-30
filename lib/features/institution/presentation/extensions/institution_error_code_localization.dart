import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// Resolves institution domain error codes into messages at the UI boundary.
extension InstitutionErrorCodeLocalization on InstitutionErrorCode {
  /// The localized message for this institution failure.
  String get message => messageKey.translate();

  /// The translation key corresponding to this institution failure.
  String get messageKey {
    return switch (this) {
      InstitutionErrorCode.invalidTime =>
        LocaleKeys.institution_errors_invalidTime,
      InstitutionErrorCode.closeBeforeOpen =>
        LocaleKeys.institution_errors_closeBeforeOpen,
      InstitutionErrorCode.overlappingRanges =>
        LocaleKeys.institution_errors_overlappingRanges,
      InstitutionErrorCode.nameRequired =>
        LocaleKeys.institution_errors_nameRequired,
      InstitutionErrorCode.addressRequired =>
        LocaleKeys.institution_errors_addressRequired,
      InstitutionErrorCode.invalidRecord =>
        LocaleKeys.institution_errors_invalidRecord,
      InstitutionErrorCode.unavailable =>
        LocaleKeys.institution_errors_unavailable,
      InstitutionErrorCode.departmentRequired =>
        LocaleKeys.institution_errors_departmentRequired,
      InstitutionErrorCode.invalidDuration =>
        LocaleKeys.institution_errors_invalidDuration,
      InstitutionErrorCode.invalidFee =>
        LocaleKeys.institution_errors_invalidFee,
      InstitutionErrorCode.invalidFastingHours =>
        LocaleKeys.institution_errors_invalidFastingHours,
      InstitutionErrorCode.preparationNoteTooLong =>
        LocaleKeys.institution_errors_preparationNoteTooLong,
    };
  }
}
