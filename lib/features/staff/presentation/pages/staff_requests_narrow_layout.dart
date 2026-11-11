part of 'staff_requests_page.dart';

/// Single-column list layout for viewports below desktop.
final class _StaffRequestsNarrowLayout extends StatelessWidget {
  const _StaffRequestsNarrowLayout({
    required this.requests,
    required this.selectedId,
  });

  final List<Appointment> requests;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    return _StaffRequestsList(
      requests: requests,
      selectedId: selectedId,
      onCardTap: (request) {
        context.read<StaffRequestSelectionCubit>().select(request.id);
        _openDetailDialog(context, request);
      },
    );
  }

  void _openDetailDialog(BuildContext context, Appointment request) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthCubit>.value(value: context.read<AuthCubit>()),
            BlocProvider<AppointmentApproveCubit>.value(
              value: context.read<AppointmentApproveCubit>(),
            ),
          ],
          child: Dialog(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppSizes.formDialogMaxWidth,
              ),
              child: _StaffRequestsDetailPanel(request: request),
            ),
          ),
        );
      },
    );
  }
}
