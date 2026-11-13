part of 'staff_requests_page.dart';

/// Header and request list, reporting every action result.
final class _StaffRequestsView extends StatelessWidget {
  const _StaffRequestsView();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppointmentApproveCubit, AppointmentActionState>(
          listener: _onApproval,
        ),
        BlocListener<AppointmentRejectCubit, AppointmentActionState>(
          listener: _onRejection,
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

  void _onApproval(BuildContext context, AppointmentActionState state) {
    _showFeedback(
      context,
      state,
      successMessage: LocaleKeys.staffRequests_approved.translate(),
    );
  }

  void _onRejection(BuildContext context, AppointmentActionState state) {
    _showFeedback(
      context,
      state,
      successMessage: LocaleKeys.staffRequests_rejected.translate(),
    );
  }

  void _showFeedback(
    BuildContext context,
    AppointmentActionState state, {
    required String successMessage,
  }) {
    final String? message;
    if (state is AppointmentActionSuccess) {
      message = successMessage;
    } else if (state is AppointmentActionFailure) {
      message = state.errorCode.message;
    } else {
      message = null;
    }

    if (message == null) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
