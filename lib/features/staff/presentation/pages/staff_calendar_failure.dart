part of 'staff_calendar_page.dart';

/// Recoverable failure that restarts calendar and workspace observation.
final class _StaffCalendarFailure extends StatelessWidget {
  const _StaffCalendarFailure({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: LocaleKeys.staffCalendar_failureTitle.translate(),
      message: message,
      icon: Icon(
        Icons.error_outline,
        color: context.colorScheme.onErrorContainer,
      ),
      iconBackground: context.colorScheme.errorContainer,
      primaryAction: FilledButton(
        onPressed: () {
          context.read<StaffAppointmentsCubit>().retry();
          context.read<StaffWorkspaceCubit>().retry();
        },
        child: AppText.label(
          LocaleKeys.staffRequests_retry.translate(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
