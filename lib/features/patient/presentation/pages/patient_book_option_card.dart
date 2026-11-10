part of 'patient_book_page.dart';

/// A tappable service or staff card; the chosen card is highlighted.
final class _PatientBookOptionCard extends StatelessWidget {
  const _PatientBookOptionCard({
    required this.leading,
    required this.title,
    required this.captions,
    required this.isSelected,
    required this.onTap,
  });

  final Widget leading;
  final String title;
  final List<String> captions;
  final bool isSelected;
  final VoidCallback onTap;

  AppSurfaceVariant get _variant {
    if (isSelected) return AppSurfaceVariant.highlighted;
    return AppSurfaceVariant.plain;
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          borderRadius: const AppRadius.medium(),
          onTap: onTap,
          child: AppSurface(
            variant: _variant,
            padding: AppSurfacePadding.dense,
            child: Row(
              spacing: AppSizes.s12,
              children: [
                leading,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.bodyStrong(title),
                      for (final caption in captions)
                        AppText.caption(caption, tone: TextTone.muted),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
