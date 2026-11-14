import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/appointment_start_comparator.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointments_overview.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_preparation_note.dart';

/// Joins, partitions and orders a patient's appointments for presentation.
final class PatientAppointmentsOverviewFactory {
  /// Injects the shared time-only appointment ordering policy.
  const PatientAppointmentsOverviewFactory(this._startComparator);

  final AppointmentStartComparator _startComparator;

  /// Creates the joined, ordered overview from the latest appointments and catalog.
  PatientAppointmentsOverview create({
    required List<Appointment> appointments,
    required ClinicCatalog catalog,
    required DateTime now,
    required PatientAppointmentActor patient,
  }) {
    final upcoming = <PatientAppointmentEntry>[];
    final past = <PatientAppointmentEntry>[];
    for (final appointment in appointments) {
      final entry = PatientAppointmentEntry(
        appointment: appointment,
        service: catalog.serviceById(appointment.serviceId),
        staff: catalog.staffById(appointment.staffId),
        branch: catalog.branchById(appointment.branchId),
        department: catalog.departmentById(appointment.departmentId),
        isUpcoming: _isUpcoming(appointment, now),
        canCancel: appointment.cancelByPatient(by: patient, at: now).isSuccess,
      );
      if (entry.isUpcoming) {
        upcoming.add(entry);
      } else {
        past.add(entry);
      }
    }
    upcoming.sort(
      (first, second) => _startComparator.compareByStartTime(
        first.appointment,
        second.appointment,
      ),
    );
    past.sort(
      (first, second) => _startComparator.compareByStartTimeDescending(
        first.appointment,
        second.appointment,
      ),
    );
    final orderedUpcoming = List<PatientAppointmentEntry>.unmodifiable(
      upcoming,
    );
    final orderedPast = List<PatientAppointmentEntry>.unmodifiable(past);
    final all = List<PatientAppointmentEntry>.unmodifiable([
      ...orderedUpcoming,
      ...orderedPast,
    ]);
    final notes = <PatientPreparationNote>[];
    for (final entry in orderedUpcoming) {
      final note = entry.preparationNote;
      if (note != null) {
        notes.add(PatientPreparationNote(entry: entry, note: note));
      }
    }
    return PatientAppointmentsOverview(
      catalog: catalog,
      upcoming: orderedUpcoming,
      past: orderedPast,
      all: all,
      next: orderedUpcoming.firstOrNull,
      preparationNotes: List<PatientPreparationNote>.unmodifiable(notes),
    );
  }

  bool _isUpcoming(Appointment appointment, DateTime now) {
    final isOpen =
        appointment.status == AppointmentStatus.pending ||
        appointment.status == AppointmentStatus.approved;
    if (isOpen == false) return false;
    if (appointment.startsAt.isBefore(now)) return false;
    return true;
  }
}
