part of 'staff_calendar_page.dart';

/// A colored block representing a scheduled appointment within a day column.
final class _StaffCalendarAppointmentBlock extends StatelessWidget {
  const _StaffCalendarAppointmentBlock({required this.appointment});

  final Appointment appointment;

  static const int _singleLine = 1;

  @override
  Widget build(BuildContext context) {
    final tone = appointment.status.calendarTone;
    final colors = context.statusColors.resolve(tone);
    final bg = colors.bg;
    final fg = colors.fg;
    final isPending = tone == AppointmentStatus.pending;
    final formattedTime = AppFormatters.formatTime(
      appointment.startsAt,
      context: context,
    );

    final content = Padding(
      padding: const AppPadding.horizontalSm(),
      child: Row(
        children: [
          AppText.label(formattedTime, color: fg, fontWeight: FontWeight.w600),
          const EmptySize.s8Width(),
          Expanded(
            child: AppText.label(
              appointment.displayPatientName,
              color: fg,
              maxLines: _singleLine,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    final Widget decorated;
    if (isPending) {
      decorated = AppDashedBorder(
        color: fg,
        strokeWidth: AppSizes.borderThin,
        radius: const AppRadius.xSmall(),
        child: Container(
          color: bg,
          alignment: Alignment.centerLeft,
          child: content,
        ),
      );
    } else {
      decorated = Container(
        decoration: BoxDecoration(
          color: bg,
          borderRadius: const AppRadius.xSmall(),
        ),
        alignment: Alignment.centerLeft,
        child: content,
      );
    }

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: () => _open(context),
        borderRadius: const AppRadius.xSmall(),
        child: Semantics(
          button: true,
          label: '$formattedTime ${appointment.displayPatientName}',
          child: decorated,
        ),
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
