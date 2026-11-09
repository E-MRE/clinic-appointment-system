part of 'patient_book_page.dart';

/// A rounded day or slot cell styled by [style]; only enabled styles tap.
final class _PatientBookChoiceCell extends StatelessWidget {
  const _PatientBookChoiceCell({
    required this.style,
    required this.minHeight,
    required this.onTap,
    required this.child,
  });

  final BookingCellStyle style;
  final double minHeight;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final cell = Semantics(
      selected: style == BookingCellStyle.selected,
      enabled: style.isEnabled,
      child: Material(
        color: style.background(colors),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: const AppRadius.medium(),
          side: style.side(colors),
        ),
        child: InkWell(
          onTap: style.isEnabled ? onTap : null,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: minHeight),
            child: Padding(
              padding: const AppPadding.allXs(),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
    if (!style.isDashed) return cell;
    return AppDashedBorder(
      color: colors.outlineVariant,
      strokeWidth: AppSizes.borderThin,
      radius: const AppRadius.medium(),
      child: cell,
    );
  }
}
