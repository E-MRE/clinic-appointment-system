part of 'department_section.dart';

/// Renders the department rows and opens the edit dialog.
final class _DepartmentRows extends StatelessWidget {
  const _DepartmentRows({required this.items});

  final List<Department> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final item in items)
          AppListTile(
            title: item.name,
            trailing: IconButton(
              tooltip: LocaleKeys.institution_editWorkingHours.tr(),
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => BlocProvider<DepartmentSaveCubit>(
                  create: (_) =>
                      AppDependency.injector.get<DepartmentSaveCubit>(),
                  child: _DepartmentEditDialog(item: item),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
