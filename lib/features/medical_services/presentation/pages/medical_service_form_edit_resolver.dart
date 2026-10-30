part of 'medical_service_form_page.dart';

/// Resolves an existing medical service by id and renders loading, edit, or not-found views.
final class _MedicalServiceFormEditResolver extends StatelessWidget {
  const _MedicalServiceFormEditResolver({required this.serviceId});

  final String serviceId;

  @override
  Widget build(BuildContext context) {
    final listState = context.watch<MedicalServiceListCubit>().state;
    if (listState is InstitutionListLoading<MedicalService>) {
      return const _MedicalServiceFormLoadingView();
    }
    if (listState is InstitutionListLoaded<MedicalService>) {
      final matches = listState.items.where((s) => s.id == serviceId);
      if (matches.isNotEmpty) {
        return _MedicalServiceFormEditBody(service: matches.first);
      }
    }
    return const _MedicalServiceFormNotFoundView();
  }
}
