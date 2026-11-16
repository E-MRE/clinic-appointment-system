import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';

/// Resolves demo failures to their translated admin feedback text.
extension DemoErrorCodeLocalization on DemoErrorCode {
  /// The localized description for this demo data error.
  String get message {
    return switch (this) {
      DemoErrorCode.doctorAccountMissing =>
        LocaleKeys.demoData_errors_doctorAccountMissing.translate(),
      DemoErrorCode.patientAccountMissing =>
        LocaleKeys.demoData_errors_patientAccountMissing.translate(),
      DemoErrorCode.linkedAccountRoleMismatch =>
        LocaleKeys.demoData_errors_linkedAccountRoleMismatch.translate(),
      DemoErrorCode.linkedAccountAmbiguous =>
        LocaleKeys.demoData_errors_linkedAccountAmbiguous.translate(),
      DemoErrorCode.invalidAccountProfile =>
        LocaleKeys.demoData_errors_invalidAccountProfile.translate(),
      DemoErrorCode.recordIdConflict =>
        LocaleKeys.demoData_errors_recordIdConflict.translate(),
      DemoErrorCode.unavailable =>
        LocaleKeys.demoData_errors_unavailable.translate(),
      DemoErrorCode.invalidScenario =>
        LocaleKeys.demoData_errors_invalidScenario.translate(),
    };
  }
}
