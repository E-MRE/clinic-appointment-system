part of 'staff_requests_page.dart';

/// Two-column layout for desktop viewports.
final class _StaffRequestsDesktopLayout extends StatelessWidget {
  const _StaffRequestsDesktopLayout({
    required this.requests,
    required this.selectedId,
    required this.now,
  });

  /// Flex weight of the list column.
  /// value = 2
  int get _listFlex => 2;

  /// Flex weight of the detail panel column.
  /// value = 3
  int get _detailFlex => 3;

  final List<Appointment> requests;
  final String? selectedId;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final selectedRequest = requests.firstWhere(
      (request) => request.id == selectedId,
      orElse: () => requests.first,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s24,
      children: [
        Expanded(
          flex: _listFlex,
          child: _StaffRequestsList(
            requests: requests,
            selectedId: selectedId,
            onCardTap: (request) {
              context.read<StaffRequestSelectionCubit>().select(request.id);
            },
            now: now,
          ),
        ),
        Expanded(
          flex: _detailFlex,
          child: _StaffRequestsDetailPanel(request: selectedRequest),
        ),
      ],
    );
  }
}
