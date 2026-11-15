import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/appointment_start_comparator.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointments_overview.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_preparation_note.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/patient_appointment_cancellation_policy.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/patient_appointment_entry_formatter.dart';

/// Joins, partitions and orders a patient's appointments for presentation.
final class PatientAppointmentsOverviewFactory {
  /// Injects ordering, cancellation, and entry presentation policies.
  const PatientAppointmentsOverviewFactory(
    this._startComparator,
    this._cancellationPolicy,
    this._entryFormatter,
  );

  final AppointmentStartComparator _startComparator;
  final PatientAppointmentCancellationPolicy _cancellationPolicy;
  final PatientAppointmentEntryFormatter _entryFormatter;

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
      final service = catalog.serviceById(appointment.serviceId);
      final staff = catalog.staffById(appointment.staffId);
      final branch = catalog.branchById(appointment.branchId);
      final department = catalog.departmentById(appointment.departmentId);
      final entry = PatientAppointmentEntry(
        appointment: appointment,
        service: service,
        staff: staff,
        branch: branch,
        department: department,
        isUpcoming: _isUpcoming(appointment, now),
        cancellationResult: _cancellationPolicy.evaluate(
          appointment: appointment,
          patient: patient,
          at: now,
        ),
        presentation: _entryFormatter.format(
          appointment: appointment,
          service: service,
          staff: staff,
          branch: branch,
          department: department,
        ),
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
