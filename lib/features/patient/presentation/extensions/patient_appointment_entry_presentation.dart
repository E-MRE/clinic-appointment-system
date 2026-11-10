import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/money_formatting.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:flutter/material.dart';

/// Localized display text of one patient appointment.
/// Missing catalog records show [LocaleKeys.common_notAvailable].
extension PatientAppointmentEntryPresentation on PatientAppointmentEntry {
  /// The current service name, or the name captured at booking.
  String get serviceName => service?.name ?? appointment.serviceName;

  /// The assigned staff member's full name.
  String get staffName => staff?.fullName ?? _missing;

  /// Branch and department (`Merkez Şube, Kardiyoloji`).
  String get location {
    return LocaleKeys.patient_appointments_location.translate(
      args: [branch?.name ?? _missing, department?.name ?? _missing],
    );
  }

  /// The fee captured at booking (`₺1.200`).
  String get fee => appointment.fee.formatted();

  /// The booked length (`20 dk`).
  String get durationLabel {
    return LocaleKeys.services_durationMinutes.translate(
      args: ['${appointment.range.durationMinutes}'],
    );
  }

  /// Start date and time for table rows (`26 Eki, 10:40`).
  String get dateTimeLabel {
    return LocaleKeys.patient_appointments_dateTime.translate(
      args: [
        AppFormatters.formatDayShortMonth(appointment.startsAt),
        '${appointment.range.start}',
      ],
    );
  }

  /// Full date and booked range for the details dialog.
  String get longDateTimeLabel {
    return LocaleKeys.patient_appointments_dialog_dateTimeValue.translate(
      args: [
        AppFormatters.formatLongDate(appointment.startsAt),
        appointment.range.label,
      ],
    );
  }

  /// Upper-case abbreviated month of the date tile (`EKİ`).
  String get monthLabel {
    return AppFormatters.formatShortMonthUpper(appointment.startsAt);
  }

  /// Day of the month of the date tile (`26`).
  String get dayLabel => '${appointment.date.day}';

  /// Full weekday name of the date tile (`Pazartesi`).
  String get weekdayLabel => appointment.date.weekday.label;

  /// The next-appointment summary line: staff, range, length, place, fee.
  String get detailLine {
    return LocaleKeys.patient_appointments_detailLine.translate(
      args: [staffName, appointment.range.label, durationLabel, location, fee],
    );
  }

  /// Who cancelled the appointment, or null when it is not cancelled.
  String? get cancellationNote {
    return switch (appointment.status) {
      AppointmentStatus.cancelledByPatient =>
        LocaleKeys.patient_appointments_cancelledByPatient.translate(),
      AppointmentStatus.cancelledByStaff =>
        LocaleKeys.patient_appointments_cancelledByStaff.translate(),
      AppointmentStatus.pending ||
      AppointmentStatus.approved ||
      AppointmentStatus.rejected ||
      AppointmentStatus.completed ||
      AppointmentStatus.noShow => null,
    };
  }

  /// The table caption: the cancellation note, else kind and length.
  String get serviceCaption {
    final note = cancellationNote;
    if (note != null) return note;
    final kind = service?.kind.label;
    if (kind == null) return durationLabel;
    return LocaleKeys.patient_appointments_serviceCaption.translate(
      args: [kind, durationLabel],
    );
  }

  /// Heading of a preparation note (`Lipid Paneli · 28 Eki`).
  String get noteHeading {
    return LocaleKeys.patient_appointments_noteHeading.translate(
      args: [
        serviceName,
        AppFormatters.formatDayShortMonth(appointment.startsAt),
      ],
    );
  }

  /// The service kind's icon, or a generic medical icon when unknown.
  IconData get kindIcon =>
      service?.kind.icon ?? Icons.medical_services_outlined;

  String get _missing => LocaleKeys.common_notAvailable.translate();
}
