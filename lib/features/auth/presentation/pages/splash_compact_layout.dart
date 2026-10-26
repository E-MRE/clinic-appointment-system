part of 'splash_page.dart';

/// Scrollable Splash for short viewports and large text.
final class _SplashCompactLayout extends StatelessWidget {
  const _SplashCompactLayout();

  @override
  Widget build(BuildContext context) {
    return const ViewportScrollView(
      child: Padding(
        padding: AppPadding.allXl(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [_SplashBrand(), EmptySize.s48Height(), _SplashProgress()],
        ),
      ),
    );
  }
}
