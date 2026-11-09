part of 'staff_requests_page.dart';

/// Header and request list, reporting every approval result.
final class _StaffRequestsView extends StatelessWidget {
  const _StaffRequestsView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppointmentApproveCubit, AppointmentActionState>(
      listener: _onApproval,
      child: AppScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PageHeader(
              title: LocaleKeys.staffRequests_title.translate(),
              subtitle: LocaleKeys.staffRequests_subtitle.translate(),
            ),
            const EmptySize.s16Height(),
            const Expanded(child: _StaffRequestsBody()),
          ],
        ),
      ),
    );
  }

  void _onApproval(BuildContext context, AppointmentActionState state) {
    final message = switch (state) {
      AppointmentActionSuccess() =>
        LocaleKeys.staffRequests_approved.translate(),
      AppointmentActionFailure(:final errorCode) => errorCode.message,
      AppointmentActionIdle() || AppointmentActionInProgress() => null,
    };
    if (message == null) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
