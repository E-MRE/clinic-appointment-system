import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_appointment_presentation.dart';
import 'package:flutter/widgets.dart';

/// Shared patient identity header for staff appointment details.
final class StaffPatientHeader extends StatelessWidget {
  /// Creates a patient header with an optional contextual subtitle.
  const StaffPatientHeader({
    required this.appointment,
    this.subtitle,
    super.key,
  });

  /// Appointment snapshot whose patient identity is shown.
  final Appointment appointment;

  /// Optional secondary text, such as when a request was submitted.
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSizes.s12,
      children: [
        AppAvatar(
          initials: appointment.patientInitials,
          size: AppAvatarSize.large,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: AppSizes.s4,
            children: [
              AppText.cardTitle(appointment.displayPatientName),
              if (subtitle != null)
                AppText.caption(subtitle!, tone: TextTone.muted),
            ],
          ),
        ),
      ],
    );
  }
}
