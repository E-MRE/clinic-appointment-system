part of 'splash_page.dart';

final class _SplashProgress extends StatelessWidget {
  const _SplashProgress();

  /// Static fill shown instead of the animation when motion is reduced.
  double get _reducedMotionValue => 0.4;

  /// Opacity of the progress track behind the indicator.
  double get _trackAlpha => 0.25;

  @override
  Widget build(BuildContext context) {
    final onBrand = context.brandColors.splashForeground;
    return AnnouncedSemantics(
      label: LocaleKeys.common_loading.translate(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: context.screenSize.select(
              mobile: AppSizes.progressWidthSm,
              tablet: AppSizes.progressWidthMd,
              desktop: AppSizes.progressWidthLg,
            ),
            child: _indicator(context, onBrand),
          ),
          const EmptySize.s12Height(),
          AppText.bodyStrong(
            LocaleKeys.common_loading.translate(),
            tone: TextTone.onBrand,
          ),
        ],
      ),
    );
  }

  LinearProgressIndicator _indicator(BuildContext context, Color color) {
    return LinearProgressIndicator(
      value: MediaQuery.disableAnimationsOf(context)
          ? _reducedMotionValue
          : null,
      color: color,
      backgroundColor: color.withValues(alpha: _trackAlpha),
      borderRadius: const AppRadius.full(),
      minHeight: AppSizes.s4,
    );
  }
}
