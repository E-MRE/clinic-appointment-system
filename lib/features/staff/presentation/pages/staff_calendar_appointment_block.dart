part of 'staff_calendar_page.dart';

/// A colored block representing a scheduled appointment within a day column.
final class _StaffCalendarAppointmentBlock extends StatelessWidget {
  const _StaffCalendarAppointmentBlock({required this.appointment});

  final Appointment appointment;

  static const int _singleLine = 1;

  @override
  Widget build(BuildContext context) {
    final onAppointmentTap = _StaffCalendarScope.maybeOf(
      context,
    )?.onAppointmentTap;
    final variant = appointment.status.badgeVariant;
    final status = variant.appointmentStatus ?? AppointmentStatus.pending;
    final colors = context.statusColors.resolve(status);
    final bg = colors.bg;
    final fg = colors.fg;
    final isPending = variant == StatusBadgeVariant.pending;
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
        onTap: () {
          onAppointmentTap?.call(appointment);
        },
        borderRadius: const AppRadius.xSmall(),
        child: Semantics(
          button: true,
          label: '$formattedTime ${appointment.displayPatientName}',
          child: decorated,
        ),
      ),
    );
  }
}
