import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_window_draft.dart';
import 'package:clinic_appointment_system/features/availability/presentation/strategies/availability_window_factory.dart';

/// Builds recurring windows from a draft's selected weekday.
final class WeeklyWindowFactory extends AvailabilityWindowFactory {
  /// Creates the weekly window strategy.
  const WeeklyWindowFactory();

  /// Combines the selected weekday with the validated range.
  @override
  WeeklyWindow build(AvailabilityWindowDraft draft, TimeRange range) =>
      WeeklyWindow(weekday: draft.weekday, range: range);
}
