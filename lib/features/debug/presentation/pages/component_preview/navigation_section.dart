part of 'component_preview_page.dart';

/// Displays navigation section samples.
final class _NavigationSection extends StatelessWidget {
  const _NavigationSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s16,
      children: [
        for (final width in _PreviewWidth.values)
          if (width.width case final double fixedWidth)
            _TierPreview(
              width: fixedWidth,
              child: SizedBox(
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
              ),
            ),
      ],
    );
  }
}
