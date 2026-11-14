import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_error_code_localization.dart';
import 'package:flutter/material.dart';

/// Shows the shared success and failure SnackBar for an appointment action.
extension AppointmentActionFeedback on BuildContext {
  String? _messageFor(AppointmentActionState state, String successMessage) {
    if (state is AppointmentActionSuccess) return successMessage;
    if (state is AppointmentActionFailure) return state.errorCode.message;
    return null;
  }

  /// Shows [successMessage] after success or the localized domain error.
  void showAppointmentActionFeedback(
    AppointmentActionState state, {
    required String successMessage,
  }) {
    final message = _messageFor(state, successMessage);
    if (message == null) return;
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: AppText.body(
          message,
          color: Theme.of(this).colorScheme.onInverseSurface,
        ),
      ),
    );
  }
}
