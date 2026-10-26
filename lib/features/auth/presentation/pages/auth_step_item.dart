part of 'auth_page.dart';

/// Identifies an appointment step with its sequence number.
final class _AuthStepItem extends StatelessWidget {
  const _AuthStepItem({required this.textKey, required this.number});

  final String number;
  final String textKey;

  @override
  Widget build(BuildContext context) {
    return _AuthBrandItem(
      textKey: textKey,
      leading: AppText.bodyStrong(number, tone: TextTone.onPrimary),
    );
  }
}
