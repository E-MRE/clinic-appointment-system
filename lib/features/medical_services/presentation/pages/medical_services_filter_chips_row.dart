part of 'medical_services_page.dart';

/// Single-select filter chips for medical service kinds with live counts.
final class _MedicalServicesFilterChipsRow extends StatelessWidget {
  const _MedicalServicesFilterChipsRow({required this.overview});

  final MedicalServiceListOverview overview;

  @override
  Widget build(BuildContext context) {
    final selectedFilter = context.watch<MedicalServiceFilterCubit>().state;
    return AppFilterChips<MedicalServiceKindFilter>(
      selected: selectedFilter,
      choices: [
        for (final filter in MedicalServiceKindFilter.values)
          AppChoice(value: filter, label: overview.chipLabel(filter)),
      ],
      onSelected: (filter) {
        context.read<MedicalServiceFilterCubit>().select(filter);
      },
    );
  }
}
