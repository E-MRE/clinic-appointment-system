part of 'medical_services_page.dart';

/// Single-select filter chips for medical service kinds with live counts.
final class _MedicalServicesFilterChipsRow extends StatelessWidget {
  const _MedicalServicesFilterChipsRow({required this.overview});

  final MedicalServiceListOverview overview;

  @override
  Widget build(BuildContext context) {
    final selectedFilter = context.watch<MedicalServiceFilterCubit>().state;
    final formatter = AppDependency.injector
        .get<MedicalServiceOverviewFormatter>();
    return AppFilterChips<MedicalServiceKindFilter>(
      selected: selectedFilter,
      choices: [
        for (final filter in MedicalServiceKindFilter.values)
          AppChoice(
            value: filter,
            label: formatter.chipLabel(overview, filter),
          ),
      ],
      onSelected: (filter) {
        context.read<MedicalServiceFilterCubit>().select(filter);
      },
    );
  }
}
