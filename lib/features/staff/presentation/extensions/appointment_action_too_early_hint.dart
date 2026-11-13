import 'package:clinic_appointment_system/core/constants/appointment_constants.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Explains when a staff action that is too early becomes available.
extension AppointmentActionTooEarlyHint on AppointmentAction {
  /// The hint for this action on [appointment], or null when the action has
  /// no time boundary.
  String? tooEarlyHint(Appointment appointment) {
    switch (this) {
      case AppointmentAction.complete:
        return LocaleKeys.staffAppointmentDialog_completeTooEarly.translate();
      case AppointmentAction.markNoShow:
        return LocaleKeys.staffAppointmentDialog_noShowTooEarly.translate(
          args: [
            AppFormatters.formatTime(
              appointment.startsAt.add(
                const Duration(
                  minutes: AppointmentConstants.noShowToleranceMinutes,
                ),
              ),
            ),
            '${AppointmentConstants.noShowToleranceMinutes}',
          ],
        );
      case AppointmentAction.approve:
      case AppointmentAction.reject:
      case AppointmentAction.cancelByPatient:
      case AppointmentAction.cancelByStaff:
        return null;
    }
  }
}
