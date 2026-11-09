part of 'patient_book_page.dart';

/// The removable department limit chosen on the appointments page.
final class _PatientBookDepartmentChip extends StatelessWidget {
  const _PatientBookDepartmentChip({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppTimeRangeChip(
        label: name,
        removeTooltip: LocaleKeys.patient_book_removeDepartment.translate(),
        onRemove: context.read<BookingSelectionCubit>().removeDepartmentLimit,
      ),
    );
  }
}
