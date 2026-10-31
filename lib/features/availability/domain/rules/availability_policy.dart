import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_window_rule.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/no_overlap_rule.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/not_in_past_rule.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/window_limit_rule.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/within_branch_hours_rule.dart';

/// An ordered specification chain whose first violation wins.
final class AvailabilityPolicy {
  /// Uses the supplied rules in their given order.
  const AvailabilityPolicy(this._rules);

  /// Checks expiry, branch hours, overlap and storage limits, in that order.
  const AvailabilityPolicy.standard()
    : _rules = const [
        NotInPastRule(),
        WithinBranchHoursRule(),
        NoOverlapRule(),
        WindowLimitRule(),
      ];

  final List<AvailabilityWindowRule> _rules;

  /// Runs every rule, propagating the first availability failure unchanged.
  void check(AvailabilityWindow candidate, AvailabilityRuleContext context) {
    for (final rule in _rules) {
      rule.check(candidate, context);
    }
  }
}
