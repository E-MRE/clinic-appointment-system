part of 'institution_page.dart';

/// Selected clinic heading, counts and edit action.
final class _InstitutionClinicHeader extends StatelessWidget {
  const _InstitutionClinicHeader({required this.clinic});

  final Clinic clinic;

  @override
  Widget build(BuildContext context) {
    final counts = InstitutionCounts.fromStates(
      context.watch<BranchListCubit>().state,
      context.watch<DepartmentListCubit>().state,
    );
    return PageHeader(
      title: clinic.name,
      subtitle: counts.label,
      actions: IconButton(
        tooltip: LocaleKeys.institution_editClinic.tr(),
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => _ClinicNameDialog(
            clinic: clinic,
            selection: InstitutionSelectionScope.of(context),
          ),
        ),
        icon: const Icon(Icons.edit_outlined),
      ),
    );
  }
}
