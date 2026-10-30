part of 'component_preview_page.dart';

/// Patient avatar and strong name cell for the appointments table preview.
final class _PreviewAppointmentPatientCell extends StatelessWidget {
  const _PreviewAppointmentPatientCell({required this.appointment});

  final _PreviewAppointment appointment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.s8,
      children: [
        AppAvatar(
          initials: appointment.patientInitials,
          size: AppAvatarSize.small,
        ),
        AppText.bodyStrong(appointment.patientName),
      ],
    );
  }
}
