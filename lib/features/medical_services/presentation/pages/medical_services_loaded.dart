part of 'medical_services_page.dart';

/// Coordinates kind filtering and presents responsive table or grouped mobile cards.
final class _MedicalServicesLoaded extends StatelessWidget {
  const _MedicalServicesLoaded({required this.services});

  final List<MedicalService> services;

  @override
  Widget build(BuildContext context) {
    final overview = MedicalServiceListOverview.from(
      services: services,
      departments: _resolveDepartments(context),
    );
    final filter = context.watch<MedicalServiceFilterCubit>().state;
    final filteredServices = services.where(filter.matches).toList();

    if (context.screenSize.isMobile) {
      return _MedicalServicesMobileView(
        overview: overview,
        services: filteredServices,
      );
    }

    return _MedicalServicesDesktopLayout(
      services: filteredServices,
      overview: overview,
    );
  }

  List<Department> _resolveDepartments(BuildContext context) {
    final departmentState = context.watch<DepartmentListCubit>().state;
    if (departmentState is InstitutionListLoaded<Department>) {
      return departmentState.items;
    }
    return const <Department>[];
  }
}
