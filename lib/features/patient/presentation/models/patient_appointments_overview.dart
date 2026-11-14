import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_preparation_note.dart';

/// The patient's appointments joined with the clinic catalog and grouped by time.
final class PatientAppointmentsOverview {
  /// Creates an overview from already-calculated appointment entries.
  const PatientAppointmentsOverview({
    required this.catalog,
    required this.upcoming,
    required this.past,
    required this.all,
    required this.next,
    required this.preparationNotes,
  });

  /// The catalog the entries were joined with.
  final ClinicCatalog catalog;

  /// Pending or approved appointments not yet started, earliest first.
  final List<PatientAppointmentEntry> upcoming;

  /// Every other appointment, latest first.
  final List<PatientAppointmentEntry> past;

  /// [upcoming] followed by [past].
  final List<PatientAppointmentEntry> all;

  /// The earliest upcoming appointment, or null when there is none.
  final PatientAppointmentEntry? next;

  /// Preparation notes of upcoming appointments, earliest first.
  final List<PatientPreparationNote> preparationNotes;
}
