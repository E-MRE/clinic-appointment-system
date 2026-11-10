import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_preparation_note.dart';

/// The patient's appointments split, ordered and joined with the catalog.
/// Widgets read these lists as they are; they do no filtering or sorting.
final class PatientAppointmentsOverview {
  /// Joins [appointments] with [catalog] and splits them at [now].
  /// [patient] decides through the domain whether each one may be cancelled.
  factory PatientAppointmentsOverview({
    required List<Appointment> appointments,
    required PatientCatalog catalog,
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
    upcoming.sort(_byStartAscending);
    past.sort(_byStartDescending);
    return PatientAppointmentsOverview._(
      catalog: catalog,
      upcoming: List<PatientAppointmentEntry>.unmodifiable(upcoming),
      past: List<PatientAppointmentEntry>.unmodifiable(past),
    );
  }

  PatientAppointmentsOverview._({
    required this.catalog,
    required this.upcoming,
    required this.past,
  }) : all = List<PatientAppointmentEntry>.unmodifiable([...upcoming, ...past]);

  /// The catalog the entries were joined with.
  final PatientCatalog catalog;

  /// Pending or approved appointments not yet started, earliest first.
  final List<PatientAppointmentEntry> upcoming;

  /// Every other appointment, latest first.
  final List<PatientAppointmentEntry> past;

  /// [upcoming] followed by [past].
  final List<PatientAppointmentEntry> all;

  /// The earliest upcoming appointment, or null when there is none.
  PatientAppointmentEntry? get next => upcoming.firstOrNull;

  /// Preparation notes of upcoming appointments, earliest first.
  List<PatientPreparationNote> get preparationNotes {
    final notes = <PatientPreparationNote>[];
    for (final entry in upcoming) {
      final note = entry.preparationNote;
      if (note != null) {
        notes.add(PatientPreparationNote(entry: entry, note: note));
      }
    }
    return List<PatientPreparationNote>.unmodifiable(notes);
  }

  /// Whether [appointment] is still open and starts at or after [now].
  static bool _isUpcoming(Appointment appointment, DateTime now) {
    final isOpen =
        appointment.status == AppointmentStatus.pending ||
        appointment.status == AppointmentStatus.approved;
    return isOpen && !appointment.startsAt.isBefore(now);
  }

  static int _byStartAscending(
    PatientAppointmentEntry first,
    PatientAppointmentEntry second,
  ) {
    return first.appointment.startsAt.compareTo(second.appointment.startsAt);
  }

  static int _byStartDescending(
    PatientAppointmentEntry first,
    PatientAppointmentEntry second,
  ) {
    return second.appointment.startsAt.compareTo(first.appointment.startsAt);
  }
}
