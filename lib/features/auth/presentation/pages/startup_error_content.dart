part of 'startup_error_page.dart';

/// Scaffolding column containing brand header, error state, and mobile actions.
final class _StartupErrorContent extends StatelessWidget {
  const _StartupErrorContent({
    required this.kind,
    required this.isMobile,
    required this.actions,
  });

  final StartupErrorKind kind;
  final bool isMobile;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBrandHeader(
          logo: Assets.images.brand.clinicLogo,
          logoSize: AppSizes.s32,
          minimumHeight: AppSizes.s48,
        ),
        Expanded(
          child: _StartupErrorState(
            kind: kind,
            isMobile: isMobile,
            actions: actions,
          ),
        ),
        if (isMobile)
          Padding(padding: const AppPadding.verticalSm(), child: actions),
      ],
    );
  }
}
