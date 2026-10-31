import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_repeat.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_window_draft.dart';

/// Editor labels derived from recurrence and selected date.
extension AvailabilityDraftPresentation on AvailabilityWindowDraft {
  /// The weekday whose branch hours constrain the current draft.
  Weekday get selectedDay {
    if (repeat == AvailabilityRepeat.oneOff) return date.weekday;
    return weekday;
  }

  /// Localized title for the current add-window sheet.
  String get sheetTitle {
    final label = switch (repeat) {
      AvailabilityRepeat.weekly => weekday.label,
      AvailabilityRepeat.oneOff => LocaleKeys.availability_oneOff.translate(),
    };
    return LocaleKeys.availability_sheetTitle.translate(args: [label]);
  }
}
