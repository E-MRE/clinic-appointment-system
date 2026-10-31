import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_window_rule.dart';

/// Enforces the candidate kind's window count cap.
final class WindowLimitRule implements AvailabilityWindowRule {
  /// Creates the rule.
  const WindowLimitRule();

  /// Throws an availability failure when this specification is violated.
  @override
  void check(AvailabilityWindow candidate, AvailabilityRuleContext context) {
    if (candidate.exceedsLimitIn(context.current)) {
      throw const AvailabilityException(AvailabilityErrorCode.tooManyWindows);
    }
  }
}
