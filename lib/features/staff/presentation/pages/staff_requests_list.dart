part of 'staff_requests_page.dart';

/// The pending requests, one row each.
final class _StaffRequestsList extends StatelessWidget {
  const _StaffRequestsList({required this.requests});

  final List<Appointment> requests;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: requests.length,
      separatorBuilder: (_, _) => const EmptySize.s12Height(),
      itemBuilder: (_, index) => _StaffRequestRow(request: requests[index]),
    );
  }
}
