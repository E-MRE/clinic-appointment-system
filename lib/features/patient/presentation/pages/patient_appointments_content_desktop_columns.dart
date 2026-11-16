part of 'patient_appointments_page.dart';

/// Places the appointments content columns side by side on desktop.
final class _PatientAppointmentsContentDesktopColumns extends StatelessWidget {
  const _PatientAppointmentsContentDesktopColumns({
    required this.primaryColumn,
    required this.secondaryColumn,
  });

  final Widget primaryColumn;
  final Widget secondaryColumn;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s24,
      children: [
        Expanded(
          flex: PatientLayoutConstants.appointmentsPrimaryFlex,
          child: primaryColumn,
        ),
        Expanded(
          flex: PatientLayoutConstants.appointmentsSecondaryFlex,
          child: secondaryColumn,
        ),
      ],
    );
  }
}
