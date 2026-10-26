part of 'auth_page.dart';

/// Brand heading with the explanatory content for the current screen.
final class _AuthBrandMessage extends StatelessWidget {
  const _AuthBrandMessage({required this.kind, super.key});

  final AuthFormKind kind;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.messageMaxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s32,
        children: [
          AppText.display(
            kind.brandTitleKey.translate(),
            tone: TextTone.onBrand,
          ),
          kind.isRegistration
              ? const _AuthRegistrationSteps()
              : const _AuthAccountRoles(),
        ],
      ),
    );
  }
}
