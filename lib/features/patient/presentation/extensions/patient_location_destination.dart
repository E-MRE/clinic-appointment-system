import 'package:clinic_appointment_system/features/patient/presentation/enums/patient_destination.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_destination_navigation.dart';

/// Resolves patient navigation from a route location.
extension PatientLocationDestination on String {
  /// Matching destination, falling back to appointments.
  PatientDestination get patientDestination {
    return PatientDestination.values.firstWhere(
      (item) => item.matches(this),
      orElse: () => PatientDestination.appointments,
    );
  }
}
