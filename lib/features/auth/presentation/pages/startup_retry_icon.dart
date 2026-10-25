part of 'startup_error_page.dart';

/// Retry glyph tinted with the enclosing button's icon color.
final class _StartupRetryIcon extends StatelessWidget {
  const _StartupRetryIcon();

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: AppSizes.retryIcon,
    child: Center(
      child: Assets.images.status.retry.svg(
        excludeFromSemantics: true,
        colorFilter: ColorFilter.mode(
          context.iconTheme.color ?? context.colorScheme.onPrimary,
          BlendMode.srcIn,
        ),
      ),
    ),
  );
}
