part of 'component_preview_page.dart';

/// Navigation shell preview sized for a tier height.
final class _NavigationPreviewShell extends StatelessWidget {
  const _NavigationPreviewShell({required this.width});

  final _PreviewWidth width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.previewHeight,
      child: AppNavigationShell(
        destinations: [
          AppNavigationDestination(
            label: LocaleKeys.componentPreview_sample.translate(),
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            badgeCount: 2,
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (_) {},
        logo: Assets.images.brand.clinicLogo,
        primaryAction: FilledButton(
          onPressed: () {},
          child: Text(LocaleKeys.common_save.translate()),
        ),
        child: Center(child: AppText.body(width.label.translate())),
      ),
    );
  }
}
