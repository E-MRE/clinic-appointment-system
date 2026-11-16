part of 'staff_calendar_page.dart';

/// The filled or dashed surface behind an appointment's time and patient.
final class _StaffCalendarAppointmentBlockSurface extends StatelessWidget {
  const _StaffCalendarAppointmentBlockSurface({
    required this.appointment,
    required this.tone,
    required this.colors,
    required this.formattedTime,
  });

  final Appointment appointment;
  final AppointmentStatus tone;
  final StatusColorPair colors;
  final String formattedTime;

  @override
  Widget build(BuildContext context) {
    if (tone == AppointmentStatus.pending) {
      return AppDashedBorder(
        color: colors.fg,
        strokeWidth: AppSizes.borderThin,
        radius: const AppRadius.xSmall(),
        child: Container(
          color: colors.bg,
          alignment: Alignment.centerLeft,
          child: _StaffCalendarAppointmentBlockTimeAndPatient(
            appointment: appointment,
            formattedTime: formattedTime,
            colors: colors,
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: const AppRadius.xSmall(),
      ),
      child: _StaffCalendarAppointmentBlockTimeAndPatient(
        appointment: appointment,
        formattedTime: formattedTime,
        colors: colors,
      ),
    );
  }
}
