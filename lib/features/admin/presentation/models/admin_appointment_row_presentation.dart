import 'package:clinic_appointment_system/core/extensions/date_time_weekday.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/admin/presentation/extensions/appointment_status_admin_actions.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/admin_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action_transition.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';

/// Display values and lifecycle actions offered for one administrator row.
final class AdminAppointmentRowPresentation {
  /// Resolves catalog names and dry-runs the actions available to [actor].
  factory AdminAppointmentRowPresentation({
    required Appointment appointment,
    required ClinicCatalog catalog,
    required AdminAppointmentActor actor,
    required DateTime at,
  }) {
    final scheduleLabel = _scheduleLabel(appointment);
    final offeredActions = <AppointmentAction>[];
    for (final action in appointment.status.adminActions) {
      final result = action.apply(appointment, by: actor, at: at);
      if (result.isSuccess) offeredActions.add(action);
    }
    final missing = LocaleKeys.common_notAvailable.translate();
    return AdminAppointmentRowPresentation._(
      appointment: appointment,
      dateTimeLabel: scheduleLabel,
      staffName: catalog.staffById(appointment.staffId)?.fullName ?? missing,
      departmentName:
          catalog.departmentById(appointment.departmentId)?.name ?? missing,
      branchName: catalog.branchById(appointment.branchId)?.name ?? missing,
      actions: List<AppointmentAction>.unmodifiable(offeredActions),
    );
  }

  AdminAppointmentRowPresentation._({
    required this.appointment,
    required this.dateTimeLabel,
    required this.staffName,
    required this.departmentName,
    required this.branchName,
    required this.actions,
  });

  /// The source domain appointment, including captured patient and service names.
  final Appointment appointment;

  /// Weekday, day, abbreviated month and appointment start time.
  final String dateTimeLabel;

  /// Current staff full name, or the localized not-available label.
  final String staffName;

  /// Current department name, or the localized not-available label.
  final String departmentName;

  /// Current branch name, or the localized not-available label.
  final String branchName;

  /// Department and branch names separated for the table location column.
  String get departmentBranchLabel => '$departmentName · $branchName';

  /// Actions accepted by the domain's dry-run transition for this row.
  final List<AppointmentAction> actions;

  static String _scheduleLabel(Appointment appointment) {
    final weekday = appointment.startsAt.toWeekday().shortLabel;
    final dayMonth = AppFormatters.formatDayShortMonth(appointment.startsAt);
    final time = AppFormatters.formatTime(appointment.startsAt);
    return '$weekday $dayMonth · $time';
  }
}
