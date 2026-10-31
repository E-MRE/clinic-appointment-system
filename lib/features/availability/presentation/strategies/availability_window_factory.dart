import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_window_draft.dart';

/// Builds a window for one recurrence choice.
/// Subclasses must supply the corresponding domain window variant.
abstract base class AvailabilityWindowFactory {
  /// Creates a stateless window strategy.
  const AvailabilityWindowFactory();

  /// Subclasses must combine the draft's recurrence selection with [range].
  /// The caller must provide an already constructed, valid time range.
  AvailabilityWindow build(AvailabilityWindowDraft draft, TimeRange range);
}
