part of 'admin_appointments_page.dart';

/// Displays the appointment count and nonzero status counts.
final class _AdminAppointmentsTableHeaderSummary extends StatelessWidget {
  /// Creates a summary from the loaded appointment state.
  const _AdminAppointmentsTableHeaderSummary({required this.state});

  final AdminAppointmentsLoaded state;

  /// Zero is the threshold for displaying appointment status counts.
  int get _noAppointments => 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s4,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText.bodyStrong(
          '${state.filteredAppointments.length} ${LocaleKeys.admin_appointmentsPage_appointmentCount.translate()}',
        ),
        for (final status in AdminStatusFilter.values)
          if ((state.statusCounts[status] ?? _noAppointments) > _noAppointments)
            AppText.body(
              '· ${state.statusCounts[status]} ${status.label.toLowerCase()}',
              tone: TextTone.muted,
            ),
      ],
    );
  }
}
