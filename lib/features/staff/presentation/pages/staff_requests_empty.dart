part of 'staff_requests_page.dart';

/// Shown when no request awaits approval.
final class _StaffRequestsEmpty extends StatelessWidget {
  const _StaffRequestsEmpty();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: LocaleKeys.staffRequests_emptyTitle.translate(),
      message: LocaleKeys.staffRequests_emptyMessage.translate(),
      icon: const Icon(Icons.inbox_outlined),
      iconBackground: context.colorScheme.surfaceContainerHighest,
    );
  }
}
