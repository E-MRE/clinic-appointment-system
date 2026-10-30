part of 'medical_services_page.dart';

/// Surface card presented on desktop and tablet when the active filter matches zero services.
final class _MedicalServicesDesktopEmpty extends StatelessWidget {
  const _MedicalServicesDesktopEmpty({required this.overview});

  final MedicalServiceListOverview overview;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: AppSurface(
        padding: AppSurfacePadding.compact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MedicalServicesFilterChipsRow(overview: overview),
            const EmptySize.s32Height(),
            const _MedicalServicesFilteredEmpty(),
            const EmptySize.s16Height(),
          ],
        ),
      ),
    );
  }
}
