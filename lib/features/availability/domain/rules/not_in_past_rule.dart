import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_window_rule.dart';

/// Rejects dated windows strictly before today.
final class NotInPastRule implements AvailabilityWindowRule {
  /// Creates the rule.
  const NotInPastRule();

  /// Throws an availability failure when this specification is violated.
  @override
  void check(AvailabilityWindow candidate, AvailabilityRuleContext context) {
    if (candidate.hasExpiredBy(context.today)) {
      throw const AvailabilityException(AvailabilityErrorCode.pastDate);
    }
  }
}
