part of 'staff_calendar_page.dart';

/// The legend row explaining appointment status colors and availability bands.
final class _StaffCalendarLegend extends StatelessWidget {
  const _StaffCalendarLegend();

  @override
  Widget build(BuildContext context) {
    final statusColors = context.statusColors;

    final pending = statusColors.resolve(AppointmentStatus.pending);
    final approved = statusColors.resolve(AppointmentStatus.approved);
    final completed = statusColors.resolve(AppointmentStatus.completed);
    final noShow = statusColors.resolve(AppointmentStatus.noShow);
    final cancelled = statusColors.resolve(AppointmentStatus.cancelled);

    return Wrap(
      spacing: AppSizes.s16,
      runSpacing: AppSizes.s8,
      children: [
        _StaffCalendarLegendItem(
          label: LocaleKeys.appointment_status_pending.translate(),
          background: pending.bg,
          foreground: pending.fg,
          isDashed: true,
        ),
        _StaffCalendarLegendItem(
          label: LocaleKeys.appointment_status_approved.translate(),
          background: approved.bg,
          foreground: approved.fg,
        ),
        _StaffCalendarLegendItem(
          label: LocaleKeys.appointment_status_completed.translate(),
          background: completed.bg,
          foreground: completed.fg,
        ),
        _StaffCalendarLegendItem(
          label: LocaleKeys.appointment_status_noShow.translate(),
          background: noShow.bg,
          foreground: noShow.fg,
        ),
        _StaffCalendarLegendItem(
          label: LocaleKeys.appointment_status_cancelled.translate(),
          background: cancelled.bg,
          foreground: cancelled.fg,
        ),
        _StaffCalendarLegendItem(
          label: LocaleKeys.staffCalendar_legend_availability.translate(),
          background: context.colorScheme.surfaceContainerLow,
          foreground: context.colorScheme.outlineVariant,
        ),
      ],
    );
  }
}
