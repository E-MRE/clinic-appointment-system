import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';

/// Polymorphic window operations; implementations must handle both variants.
abstract interface class AvailabilityWindowVisitor<R> {
  /// Implementations must handle a recurring window and return its result.
  R visitWeekly(WeeklyWindow window);

  /// Implementations must handle a dated extra window and return its result.
  R visitOneOff(OneOffWindow window);
}
