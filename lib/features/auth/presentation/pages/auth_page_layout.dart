part of 'auth_page.dart';

/// Adapts the shared form to mobile, tablet card and desktop form-half layouts.
/// On desktop, [AuthShell] owns the brand panel beside this page.
final class _AuthPageLayout extends StatelessWidget {
  const _AuthPageLayout({
    required this.kind,
    required this.child,
    required this.canNavigate,
  });
  final AuthFormKind kind;
  final Widget child;
  final bool canNavigate;

  @override
  Widget build(BuildContext context) {
    if (context.screenSize.isDesktop) {
      return Scaffold(body: _scrollingForm(context));
    }
    return AppScaffold(
      child: context.screenSize.isMobile
          ? _mobileForm(context)
          : _scrollingForm(context),
    );
  }

  Widget _mobileForm(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: kind.formWidth),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(hasScrollBody: false, child: _surface(context)),
          ],
        ),
      ),
    );
  }

  Widget _scrollingForm(BuildContext context) {
    return ViewportScrollView(
      child: Center(
        child: Padding(
          padding: context.screenSize.select(
            mobile: const AppPadding.verticalLg(),
            tablet: const AppPadding.verticalXl(),
            desktop: const AppPadding.allXxl(),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.screenSize.isTablet
                  ? kind.cardWidth
                  : kind.formWidth,
            ),
            child: _surface(context),
          ),
        ),
      ),
    );
  }

  Widget _surface(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (context.screenSize.isMobile && kind.offersBack)
          _backButton(context),
        if (context.screenSize.isMobile) Expanded(child: child) else child,
      ],
    );
    return context.screenSize.isTablet
        ? Card(
            child: Padding(
              padding: const AppPadding.authCard(),
              child: content,
            ),
          )
        : content;
  }

  Widget _backButton(BuildContext context) {
    return Row(
      spacing: AppSizes.s8,
      children: [
        IconButton(
          tooltip: LocaleKeys.common_back.translate(),
          onPressed: canNavigate ? context.pop : null,
          icon: SquareSvgIcon(
            asset: Assets.images.auth.back,
            size: AppSizes.s24,
            color: context.colorScheme.onSurface,
          ),
        ),
        Expanded(
          child: Semantics(
            header: true,
            child: Text(
              kind.titleKey.translate(),
              style: context.textTheme.titleLarge,
            ),
          ),
        ),
      ],
    );
  }
}
