import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/services/appointment_start_comparator.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_patient_history.dart';

/// Calculates a patient's completed visit summary from staff appointments.
final class StaffPatientHistoryCalculator {
  /// Injects the shared appointment start ordering policy.
  const StaffPatientHistoryCalculator(this._startComparator);

  final AppointmentStartComparator _startComparator;

  /// Filters completed visits for [patientId] and summarizes the latest visit.
  StaffPatientHistory calculate({
    required String patientId,
    required Iterable<Appointment> appointments,
  }) {
    final completedAppointments = [
      for (final appointment in appointments)
        if (appointment.patientId == patientId &&
            appointment.status == AppointmentStatus.completed)
          appointment,
    ];
    return _summarize(completedAppointments);
  }

  /// Calculates completed visit summaries for every patient in [appointments].
  Map<String, StaffPatientHistory> calculateAll(
    Iterable<Appointment> appointments,
  ) {
    final completedByPatient = <String, List<Appointment>>{};
    for (final appointment in appointments) {
      if (appointment.status != AppointmentStatus.completed) continue;
      completedByPatient
          .putIfAbsent(appointment.patientId, () => [])
          .add(appointment);
    }

    final histories = <String, StaffPatientHistory>{};
    for (final entry in completedByPatient.entries) {
      histories[entry.key] = _summarize(entry.value);
    }
    return Map<String, StaffPatientHistory>.unmodifiable(histories);
  }

  StaffPatientHistory _summarize(List<Appointment> completedAppointments) {
    completedAppointments.sort(_startComparator.compareByStartTimeDescending);
    if (completedAppointments.isEmpty) {
      return const StaffPatientHistory.empty();
    }
    return StaffPatientHistory(
      completedCount: completedAppointments.length,
      latestVisitDate: completedAppointments.first.startsAt,
    );
  }
}
