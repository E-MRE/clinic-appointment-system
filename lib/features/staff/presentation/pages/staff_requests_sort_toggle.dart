part of 'staff_requests_page.dart';

/// Two-option segmented toggle switching between date and request-time orders.
final class _StaffRequestsSortToggle extends StatelessWidget {
  const _StaffRequestsSortToggle();

  @override
  Widget build(BuildContext context) {
    final currentSort = context.watch<StaffRequestSelectionCubit>().state.sort;

    return AppTabBar<StaffRequestSort>(
      choices: [
        for (final sort in StaffRequestSort.values)
          AppChoice<StaffRequestSort>(value: sort, label: sort.label),
      ],
      selected: currentSort,
      onSelected: (sort) {
        context.read<StaffRequestSelectionCubit>().changeSort(sort);
      },
    );
  }
}
