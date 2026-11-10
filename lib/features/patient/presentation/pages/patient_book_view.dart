part of 'patient_book_page.dart';

/// Switches between catalog loading, failure and the booking content.
final class _PatientBookView extends StatelessWidget {
  const _PatientBookView({required this.patient});

  final PatientAppointmentActor patient;

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<PatientCatalogCubit>().state;
    return AppScaffold(child: _buildChild(catalogState));
  }

  Widget _buildChild(PatientCatalogState catalogState) {
    if (catalogState is PatientCatalogLoaded) {
      return _PatientBookEffects(
        catalog: catalogState.catalog,
        child: _PatientBookContent(
          catalog: catalogState.catalog,
          patient: patient,
        ),
      );
    }

    if (catalogState is PatientCatalogFailure) {
      return const _PatientBookFailure();
    }

    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.patient_book_loading.translate(),
    );
  }
}
