import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_rule_context.dart';

/// One specification in an ordered chain of availability checks.
abstract interface class AvailabilityWindowRule {
  /// Implementations must throw [AvailabilityException] on a violation
  /// and return normally when [candidate] satisfies this rule in [context].
  void check(AvailabilityWindow candidate, AvailabilityRuleContext context);
}
