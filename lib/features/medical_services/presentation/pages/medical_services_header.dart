part of 'medical_services_page.dart';

/// Responsive header displaying page title, overview subtitle and actions.
final class _MedicalServicesHeader extends StatelessWidget {
  const _MedicalServicesHeader();

  @override
  Widget build(BuildContext context) {
    final branchId = InstitutionSelectionScope.of(context).branchId;
    final String? subtitle;
    if (branchId == null) {
      subtitle = null;
    } else {
      subtitle = _resolveSubtitle(context);
    }

    return PageHeader(
      title: LocaleKeys.services_title.tr(),
      subtitle: subtitle,
      actions: const _MedicalServicesHeaderActions(),
    );
  }

  String? _resolveSubtitle(BuildContext context) {
    final serviceState = context.watch<MedicalServiceListCubit>().state;
    if (serviceState is! InstitutionListLoaded<MedicalService>) {
      return null;
    }
    final departmentState = context.watch<DepartmentListCubit>().state;
    final departments = departmentState is InstitutionListLoaded<Department>
        ? departmentState.items
        : const <Department>[];
    final overview = MedicalServiceListOverview.from(
      services: serviceState.items,
      departments: departments,
    );
    return context.screenSize.select(
      mobile: overview.mobileSubtitle,
      tablet: overview.tabletSubtitle,
      desktop: overview.desktopSubtitle,
    );
  }
}
