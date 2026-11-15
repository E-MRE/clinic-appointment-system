part of 'staff_requests_page.dart';

/// Header and request list, reporting every action result.
final class _StaffRequestsView extends StatelessWidget {
  const _StaffRequestsView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppointmentApproveCubit, AppointmentActionState>(
          listener: (context, state) {
            context.showAppointmentActionFeedback(
              state,
              successMessage: LocaleKeys.staffRequests_approved.translate(),
            );
          },
        ),
        BlocListener<AppointmentRejectCubit, AppointmentActionState>(
          listener: (context, state) {
            context.showAppointmentActionFeedback(
              state,
              successMessage: LocaleKeys.staffRequests_rejected.translate(),
            );
          },
        ),
        BlocListener<StaffAppointmentsCubit, StaffAppointmentsState>(
          listener: (context, state) {
            context.read<StaffRequestSelectionCubit>().syncRequests(
              state.pendingRequests,
            );
          },
        ),
      ],
      child: const AppScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StaffRequestsHeader(),
            EmptySize.s16Height(),
            Expanded(child: _StaffRequestsBody()),
          ],
        ),
      ),
    );
  }
}
