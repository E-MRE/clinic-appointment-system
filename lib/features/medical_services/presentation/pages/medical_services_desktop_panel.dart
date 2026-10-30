part of 'medical_services_page.dart';

/// Persistent side panel on desktop for creating and editing medical services.
final class _MedicalServicesDesktopPanel extends StatelessWidget {
  const _MedicalServicesDesktopPanel();

  double get _panelWidth => 400;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _panelWidth,
      child: const AppSurface(
        padding: AppSurfacePadding.compact,
        child: SingleChildScrollView(child: _MedicalServicesDesktopPanelBody()),
      ),
    );
  }
}
