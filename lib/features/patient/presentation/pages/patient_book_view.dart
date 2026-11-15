part of 'patient_book_page.dart';

/// Switches between catalog loading, failure and the booking content.
final class _PatientBookView extends StatelessWidget {
  const _PatientBookView({required this.patient, required this.patientName});

  final PatientAppointmentActor patient;
  final String patientName;

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<ClinicCatalogCubit>().state;
    return AppScaffold(child: _buildChild(catalogState));
  }

  Widget _buildChild(ClinicCatalogState catalogState) {
    if (catalogState is ClinicCatalogLoaded) {
      return _PatientBookEffects(
        catalog: catalogState.catalog,
        child: _PatientBookContent(
          catalog: catalogState.catalog,
          patient: patient,
          patientName: patientName,
        ),
      );
    }

    if (catalogState is ClinicCatalogFailure) {
      return const _PatientBookFailure();
    }

    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.patient_book_loading.translate(),
    );
  }
}
