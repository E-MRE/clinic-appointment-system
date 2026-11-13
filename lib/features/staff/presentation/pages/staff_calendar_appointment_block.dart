part of 'staff_calendar_page.dart';

/// A colored block representing a scheduled appointment within a day column.
final class _StaffCalendarAppointmentBlock extends StatelessWidget {
  const _StaffCalendarAppointmentBlock({required this.appointment});

  final Appointment appointment;

  int get _singleLine => 1;

  @override
  Widget build(BuildContext context) {
    final tone = appointment.status.calendarTone;
    final colors = context.statusColors.resolve(tone);

    final formattedTime = AppFormatters.formatTime(
      appointment.startsAt,
      context: context,
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: const AppRadius.xSmall(),
        child: Semantics(
          button: true,
          label: '$formattedTime ${appointment.displayPatientName}',
          child: _buildChild(tone, colors, formattedTime),
        ),
      ),
    );
  }

  Widget _buildChild(
    AppointmentStatus tone,
    StatusColorPair colors,
    String formattedTime,
  ) {
    if (tone == AppointmentStatus.pending) {
      return AppDashedBorder(
        color: colors.fg,
        strokeWidth: AppSizes.borderThin,
        radius: const AppRadius.xSmall(),
        child: Container(
          color: colors.bg,
          alignment: Alignment.centerLeft,
          child: _buildContent(formattedTime, colors),
        ),
      );
    }

    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: colors.bg,
        borderRadius: const AppRadius.xSmall(),
      ),
      child: _buildContent(formattedTime, colors),
    );
  }

  Padding _buildContent(String formattedTime, StatusColorPair colors) {
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

  /// Calls the page's tap hook when one is set; otherwise opens the staff
  /// appointment dialog.
  void _open(BuildContext context) {
    final onAppointmentTap = _StaffCalendarScope.maybeOf(
      context,
    )?.onAppointmentTap;

    if (onAppointmentTap != null) {
      onAppointmentTap(appointment);
      return;
    }
    unawaited(StaffAppointmentDialog.show(context, appointment));
  }
}
