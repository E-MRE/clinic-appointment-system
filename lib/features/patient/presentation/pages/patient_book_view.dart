part of 'patient_book_page.dart';

/// Switches between catalog loading, failure and the booking content.
final class _PatientBookView extends StatelessWidget {
  const _PatientBookView({required this.patient});

  final PatientAppointmentActor patient;

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<PatientCatalogCubit>().state;
    return AppScaffold(
      child: switch (catalogState) {
        PatientCatalogLoaded(:final catalog) => _PatientBookEffects(
          catalog: catalog,
          child: _PatientBookContent(catalog: catalog, patient: patient),
        ),
        PatientCatalogFailure() => const _PatientBookFailure(),
        PatientCatalogLoading() => LoadingState(
          variant: LoadingStateVariant.skeletonList,
          label: LocaleKeys.patient_book_loading.translate(),
        ),
      },
    );
  }
}
