part of 'patient_book_page.dart';

/// A staff member with their department and branch.
final class _PatientBookStaffCard extends StatelessWidget {
  const _PatientBookStaffCard({
    required this.staff,
    required this.catalog,
    required this.isSelected,
  });

  final Staff staff;
  final PatientCatalog catalog;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return _PatientBookOptionCard(
      leading: AppAvatar(initials: staff.initials),
      title: staff.fullName,
      captions: [staff.bookingCaption(catalog)],
      isSelected: isSelected,
      onTap: () => context.read<BookingSelectionCubit>().selectStaff(staff),
    );
  }
}
