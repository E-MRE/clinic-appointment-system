import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_rule_check_kind.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Labels and icons of [StaffRuleCheckKind].
extension StaffRuleCheckKindPresentation on StaffRuleCheckKind {
  /// The text of a passed check; [detail] fills the parentheses of the
  /// availability and working-hours texts.
  String passedLabel(String? detail) {
    return switch (this) {
      StaffRuleCheckKind.withinAvailability =>
        LocaleKeys.staffRequests_rules_withinAvailability.translate(
          args: [detail ?? ''],
        ),
      StaffRuleCheckKind.withinWorkingHours =>
        LocaleKeys.staffRequests_rules_withinWorkingHours.translate(
          args: [detail ?? ''],
        ),
      StaffRuleCheckKind.noStaffOverlap =>
        LocaleKeys.staffRequests_rules_noStaffOverlap.translate(),
      StaffRuleCheckKind.staffProvidesService =>
        LocaleKeys.staffRequests_rules_staffProvidesService.translate(),
    };
  }

  /// The text of a failed check.
  String get failedLabel {
    return switch (this) {
      StaffRuleCheckKind.withinAvailability =>
        LocaleKeys.staffRequests_rules_outsideAvailability.translate(),
      StaffRuleCheckKind.withinWorkingHours =>
        LocaleKeys.staffRequests_rules_outsideWorkingHours.translate(),
      StaffRuleCheckKind.noStaffOverlap =>
        LocaleKeys.staffRequests_rules_hasStaffOverlap.translate(),
      StaffRuleCheckKind.staffProvidesService =>
        LocaleKeys.staffRequests_rules_staffDoesNotProvideService.translate(),
    };
  }
}
