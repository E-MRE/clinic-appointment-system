import 'package:clinic_appointment_system/core/extensions/date_time_formatting.dart';
import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_localization.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/money_formatting.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry_presentation.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter/material.dart';

/// Formats localized labels and the icon for a patient appointment entry.
final class PatientAppointmentEntryFormatter {
  /// Creates a stateless appointment entry formatter.
  const PatientAppointmentEntryFormatter();

  /// Formats the appointment and its optional current catalog records.
  PatientAppointmentEntryPresentation format({
    required Appointment appointment,
    required MedicalService? service,
    required Staff? staff,
    required Branch? branch,
    required Department? department,
  }) {
    final serviceName = service?.name ?? appointment.serviceName;
    final staffName = staff?.fullName ?? _missing;
    final location = LocaleKeys.patient_appointments_location.translate(
      args: [branch?.name ?? _missing, department?.name ?? _missing],
    );
    final fee = appointment.fee.formatted();
    final durationLabel = LocaleKeys.services_durationMinutes.translate(
      args: ['${appointment.range.durationMinutes}'],
    );
    final dateTimeLabel = LocaleKeys.patient_appointments_dateTime.translate(
      args: [
        appointment.startsAt.dayShortMonthLabel(),
        '${appointment.range.start}',
      ],
    );
    final longDateTimeLabel = LocaleKeys
        .patient_appointments_dialog_dateTimeValue
        .translate(
          args: [appointment.startsAt.longDateLabel(), appointment.range.label],
        );
    final monthLabel = appointment.startsAt.shortMonthUpperLabel();
    final dayLabel = '${appointment.date.day}';
    final weekdayLabel = appointment.date.weekday.label;
    final cancellationNote = _cancellationNote(appointment);
    final kindLabel = service?.kind.label;
    final serviceCaption = _serviceCaption(
      cancellationNote: cancellationNote,
      kindLabel: kindLabel,
      durationLabel: durationLabel,
    );
    final detailLine = LocaleKeys.patient_appointments_detailLine.translate(
      args: [staffName, appointment.range.label, durationLabel, location, fee],
    );
    final noteHeading = LocaleKeys.patient_appointments_noteHeading.translate(
      args: [serviceName, appointment.startsAt.dayShortMonthLabel()],
    );

    return PatientAppointmentEntryPresentation(
      serviceName: serviceName,
      staffName: staffName,
      location: location,
      fee: fee,
      durationLabel: durationLabel,
      dateTimeLabel: dateTimeLabel,
      longDateTimeLabel: longDateTimeLabel,
      monthLabel: monthLabel,
      dayLabel: dayLabel,
      weekdayLabel: weekdayLabel,
      detailLine: detailLine,
      cancellationNote: cancellationNote,
      serviceCaption: serviceCaption,
      noteHeading: noteHeading,
      kindIcon: service?.kind.icon ?? Icons.medical_services_outlined,
    );
  }

  String? _cancellationNote(Appointment appointment) {
    final reason = appointment.statusReason;
    if (reason != null &&
        (appointment.status == AppointmentStatus.rejected ||
            appointment.status == AppointmentStatus.cancelledByStaff)) {
      return LocaleKeys.patient_appointments_reason.translate(args: [reason]);
    }
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

  String _serviceCaption({
    required String? cancellationNote,
    required String? kindLabel,
    required String durationLabel,
  }) {
    if (cancellationNote != null) return cancellationNote;
    if (kindLabel == null) return durationLabel;
    return LocaleKeys.patient_appointments_serviceCaption.translate(
      args: [kindLabel, durationLabel],
    );
  }

  String get _missing => LocaleKeys.common_notAvailable.translate();
}
