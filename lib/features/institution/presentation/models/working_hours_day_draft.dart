import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/working_hours_range_draft.dart';

/// Holds one weekday's editable open state, ranges and domain validation code.
final class WorkingHoursDayDraft {
  /// Creates a weekday draft and validates its ranges with domain value objects.
  factory WorkingHoursDayDraft({
    required Weekday weekday,
    required bool isOpen,
    required List<WorkingHoursRangeDraft> ranges,
  }) {
    final copiedRanges = List<WorkingHoursRangeDraft>.unmodifiable(ranges);
    InstitutionErrorCode? error;
    if (isOpen) {
      try {
        WorkingHours({
          weekday: copiedRanges.map((range) => range.toTimeRange()).toList(),
        });
      } on InstitutionException catch (exception) {
        error = exception.code;
      }
    }
    return WorkingHoursDayDraft._(
      weekday: weekday,
      isOpen: isOpen,
      ranges: copiedRanges,
      error: error,
    );
  }

  const WorkingHoursDayDraft._({
    required this.weekday,
    required this.isOpen,
    required this.ranges,
    required this.error,
  });

  /// The weekday represented by this draft.
  final Weekday weekday;

  /// Whether this weekday is open in the edited schedule.
  final bool isOpen;

  /// The editable ranges for this weekday.
  final List<WorkingHoursRangeDraft> ranges;

  /// The domain validation error for this weekday, if any.
  final InstitutionErrorCode? error;
}
