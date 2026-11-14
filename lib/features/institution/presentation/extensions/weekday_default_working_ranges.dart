import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/working_hours_range_draft.dart';

/// Supplies the default editor ranges for a weekday.
extension WeekdayDefaultWorkingRanges on Weekday {
  /// The standard workday range from Monday through Friday, or no range.
  List<WorkingHoursRangeDraft> get defaultWorkingRanges {
    if (index > Weekday.friday.index) return const [];
    return [WorkingHoursRangeDraft.workday()];
  }
}
