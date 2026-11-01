import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window_visitor.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';

/// Exposes visitor dispatch without inspecting runtime types.
final class WindowNameVisitor implements AvailabilityWindowVisitor<String> {
  /// Creates the visitor.
  const WindowNameVisitor();

  /// Labels a recurring window.
  @override
  String visitWeekly(WeeklyWindow window) => 'weekly';

  /// Labels an extra window.
  @override
  String visitOneOff(OneOffWindow window) => 'one-off';
}
