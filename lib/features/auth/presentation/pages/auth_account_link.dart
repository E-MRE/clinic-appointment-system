part of 'auth_page.dart';

/// Navigation link switching between sign-in and patient registration.
final class _AuthAccountLink extends StatelessWidget {
  const _AuthAccountLink({
    required this.footer,
    required this.enabled,
    required this.centered,
  });

  final AuthFooterConfig footer;
  final bool enabled;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: centered ? WrapAlignment.center : WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        AppText.bodyStrong(footer.promptKey.translate()),
        TextButton(
          onPressed: enabled
              ? () {
                  context.go(footer.alternateRoute);
                }
              : null,
          child: Text(footer.actionKey.translate()),
        ),
      ],
    );
  }
}
