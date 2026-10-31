import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_repeat.dart';
import 'package:clinic_appointment_system/features/availability/presentation/strategies/availability_window_factory.dart';
import 'package:clinic_appointment_system/features/availability/presentation/strategies/one_off_window_factory.dart';
import 'package:clinic_appointment_system/features/availability/presentation/strategies/weekly_window_factory.dart';

/// Selects the construction strategy for an availability recurrence.
extension AvailabilityRepeatWindowFactory on AvailabilityRepeat {
  /// The stateless factory corresponding to this recurrence choice.
  AvailabilityWindowFactory get windowFactory => switch (this) {
    AvailabilityRepeat.weekly => const WeeklyWindowFactory(),
    AvailabilityRepeat.oneOff => const OneOffWindowFactory(),
  };
}
