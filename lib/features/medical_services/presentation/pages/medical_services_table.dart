part of 'medical_services_page.dart';

/// Wide table rendering medical service records with columns for service, department, duration and fee.
final class _MedicalServicesTable extends StatelessWidget {
  const _MedicalServicesTable({required this.services, required this.overview});

  final List<MedicalService> services;
  final MedicalServiceListOverview overview;

  /// Minimum scrollable width ensuring columns do not compress below readability.
  double get _minTableWidth => 600;

  @override
  Widget build(BuildContext context) {
    return AppDataTable<MedicalService>(
      rows: services,
      minWidth: _minTableWidth,
      rowVerticalPadding: AppSizes.s8,
      header: Padding(
        padding: const AppPadding.allLg(),
        child: _MedicalServicesFilterChipsRow(overview: overview),
      ),
      columns: _columns,
    );
  }

  List<AppTableColumn<MedicalService>> get _columns {
    return [
      AppTableColumn<MedicalService>(
        label: LocaleKeys.services_columns_service.tr(),
        cellBuilder: (context, service) {
          return _MedicalServicesServiceCell(service: service);
        },
      ),
      AppTableColumn<MedicalService>(
        label: LocaleKeys.services_columns_department.tr(),
        cellBuilder: (context, service) {
          return AppText.body(overview.departmentName(service.departmentId));
        },
      ),
      AppTableColumn<MedicalService>(
        label: LocaleKeys.services_columns_duration.tr(),
        cellBuilder: (context, service) {
          return AppText.body(service.duration.formatted);
        },
      ),
      AppTableColumn<MedicalService>(
        label: LocaleKeys.services_columns_fee.tr(),
        cellBuilder: (context, service) {
          return AppText.bodyStrong(service.fee.formatted(context));
        },
      ),
      AppTableColumn<MedicalService>(
        label: '',
        semanticsLabel: LocaleKeys.services_columns_actions.tr(),
        alignment: AppTableAlignment.end,
        cellBuilder: (context, service) {
          return IconButton(
            onPressed: () => context.go(AppRoutes.serviceEdit(service.id)),
            tooltip: LocaleKeys.services_editTooltip.tr(),
            icon: const Icon(Icons.edit_outlined),
          );
        },
      ),
    ];
  }
}
