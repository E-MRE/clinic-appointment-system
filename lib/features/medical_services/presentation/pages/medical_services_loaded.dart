part of 'medical_services_page.dart';

/// Coordinates kind filtering and presents responsive table or grouped mobile cards.
final class _MedicalServicesLoaded extends StatelessWidget {
  const _MedicalServicesLoaded();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<MedicalServiceListCubit>().state;
    if (state is! MedicalServiceListLoaded) return const SizedBox.shrink();

    if (context.screenSize.isMobile) {
      return _MedicalServicesMobileView(
        overview: state.overview,
        groups: state.groups,
      );
    }

    return _MedicalServicesTablePanel(
      services: state.filteredServices,
      overview: state.overview,
    );
  }
}
