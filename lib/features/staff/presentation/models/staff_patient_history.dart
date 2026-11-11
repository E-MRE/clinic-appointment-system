import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';
import 'package:equatable/equatable.dart';

/// Summarises past completed visits of a patient with a staff member.
final class StaffPatientHistory extends Equatable {
  /// Creates a patient history summary.
  const StaffPatientHistory({
    required this.completedCount,
    this.latestVisitDate,
  });

  /// Summarises the completed visits of [patientId] among the staff
  /// member's own [appointments].
  factory StaffPatientHistory.fromAppointments({
    required String patientId,
    required Iterable<Appointment> appointments,
  }) {
    final completed = [
      for (final appointment in appointments)
        if (appointment.patientId == patientId &&
            appointment.status == AppointmentStatus.completed)
          appointment,
    ];

    if (completed.isEmpty) {
      return const StaffPatientHistory.empty();
    }

    completed.sort(
      (first, second) => second.startsAt.compareTo(first.startsAt),
    );

    return StaffPatientHistory(
      completedCount: completed.length,
      latestVisitDate: completed.first.startsAt,
    );
  }

  /// An empty history representing no prior completed visits.
  const StaffPatientHistory.empty()
    : completedCount = 0,
      latestVisitDate = null;

  /// The total number of completed visits with this staff member.
  final int completedCount;

  /// The start date and time of the most recent completed visit, or null.
  final DateTime? latestVisitDate;

  /// Whether at least one completed visit exists.
  bool get hasHistory => completedCount > 0;

  /// Localized completed visits label (`"{n} tamamlandı"`).
  String get completedLabel {
    return LocaleKeys.staffRequests_history_completed.translate(
      args: ['$completedCount'],
    );
  }

  /// Localized latest visit label (`"Son ziyaret: {14 Eylül}"`), or null when empty.
  String? get lastVisitLabel {
    final latest = latestVisitDate;
    if (latest == null) return null;
    return LocaleKeys.staffRequests_history_lastVisit.translate(
      args: [AppFormatters.formatDayMonth(latest)],
    );
  }

  @override
  List<Object?> get props => [completedCount, latestVisitDate];
}
