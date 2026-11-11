part of 'staff_requests_page.dart';

/// The pending requests rendered as selectable cards.
final class _StaffRequestsList extends StatelessWidget {
  const _StaffRequestsList({
    required this.requests,
    required this.selectedId,
    required this.onCardTap,
  });

  final List<Appointment> requests;
  final String? selectedId;
  final ValueChanged<Appointment> onCardTap;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: requests.length,
      separatorBuilder: (_, _) => const EmptySize.s12Height(),
      itemBuilder: (context, index) {
        final request = requests[index];
        return _StaffRequestCard(
          request: request,
          isSelected: request.id == selectedId,
          onTap: () => onCardTap(request),
        );
      },
    );
  }
}
