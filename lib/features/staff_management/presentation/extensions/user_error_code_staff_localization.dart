import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

/// Resolves profile and assignment failures for staff forms.
extension UserErrorCodeStaffLocalization on UserErrorCode {
  /// The localized staff message, including recovery instructions when needed.
  String get staffMessage => switch (this) {
    UserErrorCode.profileMissing =>
      LocaleKeys.staff_errors_profileMissing.translate(),
    UserErrorCode.invalidProfile =>
      LocaleKeys.staff_errors_invalidProfile.translate(),
    UserErrorCode.unavailable =>
      LocaleKeys.staff_errors_unavailable.translate(),
    UserErrorCode.fullNameRequired =>
      LocaleKeys.staff_errors_fullNameRequired.translate(),
    UserErrorCode.invalidEmail =>
      LocaleKeys.staff_errors_invalidEmail.translate(),
    UserErrorCode.branchRequired =>
      LocaleKeys.staff_errors_branchRequired.translate(),
    UserErrorCode.departmentRequired =>
      LocaleKeys.staff_errors_departmentRequired.translate(),
    UserErrorCode.specialtyRequired =>
      LocaleKeys.staff_errors_specialtyRequired.translate(),
    UserErrorCode.duplicateService =>
      LocaleKeys.staff_errors_duplicateService.translate(),
    UserErrorCode.tooManyServices =>
      LocaleKeys.staff_errors_tooManyServices.translate(),
    UserErrorCode.ineligibleService =>
      LocaleKeys.staff_errors_ineligibleService.translate(),
    UserErrorCode.orphanAccount =>
      LocaleKeys.staff_errors_orphanAccount.translate(),
  };
}
