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
            kind.config.brandTitleKey.translate(),
            tone: TextTone.onBrand,
          ),
          kind.isRegistration
              ? _buildRegistrationSteps()
              : _buildAccountRoles(context),
        ],
      ),
    );
  }

  /// Builds the three appointment steps shown during registration.
  Widget _buildRegistrationSteps() {
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

  /// Builds the account-role descriptions shown on sign-in screens.
  Widget _buildAccountRoles(BuildContext context) {
    return Column(
      children: [
        _buildRoleItem(
          context,
          textKey: LocaleKeys.auth_patientDescription,
          asset: Assets.images.auth.patient,
        ),
        _buildRoleItem(
          context,
          textKey: LocaleKeys.auth_staffDescription,
          asset: Assets.images.auth.staff,
        ),
        _buildRoleItem(
          context,
          textKey: LocaleKeys.auth_adminDescription,
          asset: Assets.images.auth.admin,
        ),
      ],
    );
  }

  /// Builds a role row from its description and SVG asset.
  Widget _buildRoleItem(
    BuildContext context, {
    required String textKey,
    required SvgGenImage asset,
  }) {
    return _AuthBrandItem(
      textKey: textKey,
      leading: SquareSvgIcon(
        asset: asset,
        size: AppSizes.retryIcon,
        color: context.colorScheme.onPrimary,
      ),
    );
  }
}
