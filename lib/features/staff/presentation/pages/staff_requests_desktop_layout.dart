part of 'staff_requests_page.dart';

/// Two-column layout for desktop viewports.
final class _StaffRequestsDesktopLayout extends StatelessWidget {
  const _StaffRequestsDesktopLayout({
    required this.requests,
    required this.selectedId,
  });

  /// Flex weight of the list column.
  /// value = 2
  static const int _listFlex = 2;

  /// Flex weight of the detail panel column.
  /// value = 3
  static const int _detailFlex = 3;

  final List<Appointment> requests;
  final String? selectedId;

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
