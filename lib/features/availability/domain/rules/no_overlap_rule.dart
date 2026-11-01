import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_window_rule.dart';

/// Rejects a candidate intersecting an existing window on a shared day.
final class NoOverlapRule implements AvailabilityWindowRule {
  /// Creates the rule.
  const NoOverlapRule();

  /// Throws an availability failure when this specification is violated.
  @override
  void check(AvailabilityWindow candidate, AvailabilityRuleContext context) {
    final conflict = context.current.conflictOf(candidate);
    if (conflict != null) {
      throw AvailabilityException(
        AvailabilityErrorCode.overlappingWindow,
        conflict: conflict,
      );
    }
  }
}
