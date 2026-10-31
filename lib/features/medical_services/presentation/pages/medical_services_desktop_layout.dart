part of 'medical_services_page.dart';

/// Places [child] beside the persistent editor panel on desktop once the
/// services are loaded, so the panel stays available for an empty branch too.
final class _MedicalServicesDesktopLayout extends StatelessWidget {
  const _MedicalServicesDesktopLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppSidePanelLayout(
      showsPanel: _showsPanel(context),
      panel: const AppSidePanel(child: _MedicalServicesDesktopPanelBody()),
      child: child,
    );
  }

  bool _showsPanel(BuildContext context) {
    final serviceState = context.watch<MedicalServiceListCubit>().state;
    return context.screenSize.isDesktop &&
        serviceState is InstitutionListLoaded<MedicalService>;
  }
}
