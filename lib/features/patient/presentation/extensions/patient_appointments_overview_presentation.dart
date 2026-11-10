import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointments_overview.dart';

/// Localized summary text of the patient's appointments.
extension PatientAppointmentsOverviewPresentation
    on PatientAppointmentsOverview {
  /// The header greeting naming [firstName] and the upcoming count.
  String greeting(String firstName) {
    if (upcoming.isEmpty) {
      return LocaleKeys.patient_appointments_greetingEmpty.translate(
        args: [firstName],
      );
    }
    return LocaleKeys.patient_appointments_greeting.translate(
      args: [firstName, '${upcoming.length}'],
    );
  }
}
