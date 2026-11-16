part of 'patient_book_page.dart';

/// Switches between catalog loading, failure and booking content.
final class _PatientBookViewChild extends StatelessWidget {
  const _PatientBookViewChild({
    required this.catalogState,
    required this.patient,
    required this.patientName,
  });

  final ClinicCatalogState catalogState;
  final PatientAppointmentActor patient;
  final String patientName;

  @override
  Widget build(BuildContext context) {
    final currentCatalogState = catalogState;
    if (currentCatalogState is ClinicCatalogLoaded) {
      return _PatientBookEffects(
        catalog: currentCatalogState.catalog,
        child: _PatientBookContent(
          catalog: currentCatalogState.catalog,
          patient: patient,
          patientName: patientName,
        ),
      );
    }

    if (currentCatalogState is ClinicCatalogFailure) {
      return const _PatientBookFailure();
    }

    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.patient_book_loading.translate(),
    );
  }
}
