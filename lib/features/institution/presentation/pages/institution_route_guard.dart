part of 'institution_route_scope.dart';

/// Resolves a route clinic before showing its nested page.
final class _InstitutionRouteGuard extends StatelessWidget {
  const _InstitutionRouteGuard({
    required this.routeClinicId,
    required this.child,
  });

  final String? routeClinicId;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final clinicId = routeClinicId;
    if (clinicId == null) return child;
    return InstitutionListView<Clinic, ClinicListCubit>(
      emptyTitle: LocaleKeys.institution_notFound.tr(),
      emptyMessage: LocaleKeys.institution_notFoundDescription.tr(),
      onRetry: context.read<ClinicListCubit>().retry,
      loadedBuilder: (items) {
        if (items.any((clinic) => clinic.id == clinicId)) return child;
        return const AppScaffold(child: InstitutionNotFound());
      },
    );
  }
}
