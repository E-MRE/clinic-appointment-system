part of 'staff_calendar_page.dart';

/// The appointment's formatted time and patient name in one line.
final class _StaffCalendarAppointmentBlockTimeAndPatient
    extends StatelessWidget {
  const _StaffCalendarAppointmentBlockTimeAndPatient({
    required this.appointment,
    required this.formattedTime,
    required this.colors,
  });

  final Appointment appointment;
  final String formattedTime;
  final StatusColorPair colors;

  /// Maximum number of lines displayed for the patient name.
  int get _singleLine => 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPadding.horizontalSm(),
      child: Row(
        children: [
          AppText.label(
            formattedTime,
            color: colors.fg,
            fontWeight: FontWeight.w600,
          ),
          const EmptySize.s8Width(),
          Expanded(
            child: AppText.label(
              appointment.displayPatientName,
              color: colors.fg,
              maxLines: _singleLine,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
