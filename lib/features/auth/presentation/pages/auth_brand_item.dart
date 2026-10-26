part of 'auth_page.dart';

/// Shared layout for explanatory items in the desktop brand panel.
/// Subclasses supply an icon or a step number for the leading slot.
final class _AuthBrandItem extends StatelessWidget {
  const _AuthBrandItem({required this.textKey, required this.leading});

  final String textKey;

  /// Builds the role icon or appointment-step number.
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPadding.verticalSm(),
      child: MergeSemantics(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox.square(
              dimension: AppSizes.s32,
              child: Center(child: leading),
            ),
            const EmptySize.s12Width(),
            Expanded(
              child: Text(
                textKey.translate(),
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
