import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';

/// An upcoming appointment paired with the preparation its service needs.
final class PatientPreparationNote {
  /// Pairs [entry] with its localized [note].
  const PatientPreparationNote({required this.entry, required this.note});

  /// The upcoming appointment.
  final PatientAppointmentEntry entry;

  /// The localized preparation text.
  final String note;
}
