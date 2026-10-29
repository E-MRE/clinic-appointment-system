part of 'splash_page.dart';

final class _SplashBrand extends StatelessWidget {
  const _SplashBrand();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.messageMaxWidth),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _SplashBrandLogo(),
          EmptySize.s24Height(),
          _SplashBrandTitles(),
        ],
      ),
    );
  }
}
