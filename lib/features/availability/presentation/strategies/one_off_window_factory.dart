import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_window_draft.dart';
import 'package:clinic_appointment_system/features/availability/presentation/strategies/availability_window_factory.dart';

/// Builds dated extra windows from a draft's selected date.
final class OneOffWindowFactory extends AvailabilityWindowFactory {
  /// Creates the dated window strategy.
  const OneOffWindowFactory();

  /// Combines the selected date with the validated range.
  @override
  OneOffWindow build(AvailabilityWindowDraft draft, TimeRange range) =>
      OneOffWindow(date: draft.date, range: range);
}
