import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';

/// Localized schedule text of an appointment.
extension AppointmentScheduleLabel on Appointment {
  /// Start date and booked range (`26 Eki, 10:40–11:00`).
  String get dateTimeLabel {
    return LocaleKeys.appointment_dateTime.translate(
      args: [AppFormatters.formatDayShortMonth(startsAt), range.label],
    );
  }
}
