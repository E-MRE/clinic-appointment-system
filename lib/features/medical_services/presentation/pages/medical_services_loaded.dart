part of 'medical_services_page.dart';

/// Coordinates kind filtering and presents responsive table or grouped mobile cards.
final class _MedicalServicesLoaded extends StatelessWidget {
  const _MedicalServicesLoaded({required this.services});

  final List<MedicalService> services;

  @override
  Widget build(BuildContext context) {
    final departmentState = context.watch<DepartmentListCubit>().state;
    final departments = departmentState is InstitutionListLoaded<Department>
        ? departmentState.items
        : const <Department>[];
    final overview = MedicalServiceListOverview.from(
      services: services,
      departments: departments,
    );
    final filter = context.watch<MedicalServiceFilterCubit>().state;
    final filteredServices = services.where(filter.matches).toList();

    if (context.screenSize.isMobile) {
      return _MedicalServicesMobileView(
        overview: overview,
        services: filteredServices,
      );
    }

    if (filteredServices.isEmpty) {
      return _MedicalServicesDesktopEmpty(overview: overview);
    }

    return SingleChildScrollView(
      child: _MedicalServicesTable(
        services: filteredServices,
        overview: overview,
      ),
    );
  }
}
