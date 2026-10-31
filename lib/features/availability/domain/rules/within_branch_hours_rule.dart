import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_window_rule.dart';

/// Requires a window to fit one uninterrupted branch working range.
final class WithinBranchHoursRule implements AvailabilityWindowRule {
  /// Creates the rule.
  const WithinBranchHoursRule();

  /// Throws an availability failure when this specification is violated.
  @override
  void check(AvailabilityWindow candidate, AvailabilityRuleContext context) {
    if (context.branchHours.isClosedOn(candidate.weekday)) {
      throw const AvailabilityException(AvailabilityErrorCode.branchClosed);
    }
    if (!candidate.fitsWithin(context.branchHours)) {
      throw const AvailabilityException(
        AvailabilityErrorCode.outsideBranchHours,
      );
    }
  }
}
