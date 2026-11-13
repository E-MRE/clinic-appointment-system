import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_rule_check_kind.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Labels and icons of [StaffRuleCheckKind].
extension StaffRuleCheckKindPresentation on StaffRuleCheckKind {
  /// The text of a passed check; [detail] fills the parentheses of the
  /// availability and working-hours texts.
  String passedLabel(String? detail) {
    switch (this) {
      case StaffRuleCheckKind.withinAvailability:
        return LocaleKeys.staffRequests_rules_withinAvailability.translate(
          args: [detail ?? ''],
        );
      case StaffRuleCheckKind.withinWorkingHours:
        return LocaleKeys.staffRequests_rules_withinWorkingHours.translate(
          args: [detail ?? ''],
        );
      case StaffRuleCheckKind.noStaffOverlap:
        return LocaleKeys.staffRequests_rules_noStaffOverlap.translate();
      case StaffRuleCheckKind.staffProvidesService:
        return LocaleKeys.staffRequests_rules_staffProvidesService.translate();
    }
  }

  /// The text of a failed check.
  String get failedLabel {
    switch (this) {
      case StaffRuleCheckKind.withinAvailability:
        return LocaleKeys.staffRequests_rules_outsideAvailability.translate();
      case StaffRuleCheckKind.withinWorkingHours:
        return LocaleKeys.staffRequests_rules_outsideWorkingHours.translate();
      case StaffRuleCheckKind.noStaffOverlap:
        return LocaleKeys.staffRequests_rules_hasStaffOverlap.translate();
      case StaffRuleCheckKind.staffProvidesService:
        return LocaleKeys.staffRequests_rules_staffDoesNotProvideService
            .translate();
    }
  }
}
