part of 'auth_page.dart';

/// Presents the three appointment steps shown during registration.
final class _AuthRegistrationSteps extends StatelessWidget {
  const _AuthRegistrationSteps();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AuthBrandItem(
          textKey: LocaleKeys.auth_stepService,
          leading: AppText.bodyStrong('1', tone: TextTone.onPrimary),
        ),
        _AuthBrandItem(
          textKey: LocaleKeys.auth_stepDoctor,
          leading: AppText.bodyStrong('2', tone: TextTone.onPrimary),
        ),
        _AuthBrandItem(
          textKey: LocaleKeys.auth_stepApproval,
          leading: AppText.bodyStrong('3', tone: TextTone.onPrimary),
        ),
      ],
    );
  }
}
