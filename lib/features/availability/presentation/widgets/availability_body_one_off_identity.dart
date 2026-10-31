part of 'availability_body.dart';

/// Localized dated window title and recurrence explanation.
final class _AvailabilityOneOffIdentity extends StatelessWidget {
  const _AvailabilityOneOffIdentity({required this.window});
  final OneOffWindow window;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s4,
      children: [
        AppText.bodyStrong(
          window.accept(const AvailabilityWindowLabelVisitor()),
        ),
        AppText.caption(
          LocaleKeys.availability_oneOffSubtitle.translate(),
          tone: TextTone.muted,
        ),
      ],
    );
  }
}
