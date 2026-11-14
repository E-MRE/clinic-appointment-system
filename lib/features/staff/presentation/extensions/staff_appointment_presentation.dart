import 'package:clinic_appointment_system/core/extensions/date_time_weekday.dart';
import 'package:clinic_appointment_system/core/extensions/person_name_parts.dart';
import 'package:clinic_appointment_system/core/extensions/relative_time_label.dart';
import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/money_formatting.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Presentation helpers for appointment requests reviewed by staff.
extension StaffAppointmentPresentation on Appointment {
  /// Display name of the requesting patient, falling back to a localized
  /// generic title when the stored name is blank.
  String get displayPatientName {
    final trimmed = patientName.trim();
    if (trimmed.isNotEmpty) return trimmed;
    return LocaleKeys.staffRequests_fallbackPatientName.translate();
  }

  /// Initials derived from [displayPatientName].
  String get patientInitials => displayPatientName.initials;

  /// Line describing the weekday, date, time and service name.
  String get scheduleAndServiceLabel {
    final weekday = startsAt.toWeekday().shortLabel;
    final dayMonth = AppFormatters.formatDayShortMonth(startsAt);
    final time = AppFormatters.formatTime(startsAt);
    return '$weekday $dayMonth · $time · $serviceName';
  }

  /// Localized distance from the request creation instant back from [now].
  String requestedAgoLabel(DateTime now) {
    if (history.isEmpty) return '';
    final relative = history.first.at.relativeLabel(now);
    return LocaleKeys.staffRequests_requestedAgo.translate(args: [relative]);
  }

  /// Formats the date and time range for the request detail panel.
  String get scheduleRangeLabel {
    final weekday = startsAt.toWeekday().shortLabel;
    final dayMonth = AppFormatters.formatDayShortMonth(startsAt);
    return '$weekday $dayMonth · ${range.label}';
  }

  /// Formats duration and fee for the request detail panel.
  String get durationAndFeeLabel {
    final duration = LocaleKeys.services_durationMinutes.translate(
      args: ['${range.durationMinutes}'],
    );
    return '$duration · ${fee.formatted()}';
  }
}
