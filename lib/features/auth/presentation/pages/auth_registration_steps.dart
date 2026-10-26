part of 'auth_page.dart';

/// Presents the three appointment steps from the approved registration design.
final class _AuthRegistrationSteps extends StatelessWidget {
  const _AuthRegistrationSteps();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _AuthStepItem(textKey: LocaleKeys.auth_stepService, number: '1'),
        _AuthStepItem(textKey: LocaleKeys.auth_stepDoctor, number: '2'),
        _AuthStepItem(textKey: LocaleKeys.auth_stepApproval, number: '3'),
      ],
    );
  }
}
