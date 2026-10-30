part of 'medical_services_page.dart';

/// Places [child] beside the persistent editor panel on desktop once the
/// services are loaded, so the panel stays available for an empty branch too.
final class _MedicalServicesDesktopLayout extends StatelessWidget {
  const _MedicalServicesDesktopLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (_showsPanel(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.s16,
        children: [
          Expanded(child: child),
          const _MedicalServicesDesktopPanel(),
        ],
      );
    }
    return child;
  }

  bool _showsPanel(BuildContext context) {
    final serviceState = context.watch<MedicalServiceListCubit>().state;
    return context.screenSize.isDesktop &&
        serviceState is InstitutionListLoaded<MedicalService>;
  }
}
