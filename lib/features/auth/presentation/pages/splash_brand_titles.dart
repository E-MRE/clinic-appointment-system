part of 'splash_page.dart';

/// App name and subtitle texts on the splash screen.
final class _SplashBrandTitles extends StatelessWidget {
  const _SplashBrandTitles();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.display(
          LocaleKeys.appName.translate(),
          textAlign: TextAlign.center,
          tone: TextTone.onBrand,
        ),
        const EmptySize.s8Height(),
        AppText.body(
          LocaleKeys.splash_subtitle.translate(),
          textAlign: TextAlign.center,
          tone: TextTone.onBrand,
        ),
      ],
    );
  }
}
