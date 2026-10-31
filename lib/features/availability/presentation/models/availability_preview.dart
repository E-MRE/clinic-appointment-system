import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/services/slot_generator.dart';
import 'package:clinic_appointment_system/features/availability/presentation/visitors/availability_window_label_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';

/// Pure presentation of the slots a completed availability draft would open.
final class AvailabilityPreview {
  /// Captures a window and its assigned service durations.
  AvailabilityPreview(
    this.window,
    List<ServiceDuration> durations,
    this.generator,
  ) : durations = List.unmodifiable(durations);

  /// The candidate availability window.
  final AvailabilityWindow window;

  /// Assigned durations in display order.
  final List<ServiceDuration> durations;

  /// Counts complete appointment slots without creating them.
  final SlotGenerator generator;

  /// The localized window description and optional slot counts.
  String get message {
    final added = LocaleKeys.availability_windowAdded.translate(
      args: [window.accept(const AvailabilityWindowLabelVisitor())],
    );
    if (durations.isEmpty) return added;
    if (durations.length == _singleDuration) {
      final duration = durations.single;
      return LocaleKeys.availability_previewSingle.translate(
        args: [
          added,
          '${duration.minutes}',
          '${generator.slotCount(window.range, duration)}',
        ],
      );
    }
    final counts = durations
        .map(
          (duration) => LocaleKeys.availability_previewDuration.translate(
            args: [
              '${duration.minutes}',
              '${generator.slotCount(window.range, duration)}',
            ],
          ),
        )
        .join(' · ');
    return LocaleKeys.availability_previewMultiple.translate(
      args: [added, counts],
    );
  }

  int get _singleDuration => 1;
}
