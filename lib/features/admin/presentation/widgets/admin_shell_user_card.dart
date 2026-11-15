part of 'admin_shell.dart';

/// Desktop identity footer resolved from the signed-in administrator profile.
final class _AdminShellUserCard extends StatelessWidget {
  const _AdminShellUserCard();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    if (state is AuthSignedIn) {
      return AppNavigationUserCard(
        initials: state.user.initials,
        name: state.user.fullName,
        subtitle: LocaleKeys.roles_admin.tr(),
        signOutTooltip: LocaleKeys.availability_signOut.tr(),
        onSignOut: context.read<AuthCubit>().signOut,
      );
    }
    return const SizedBox.shrink();
  }
}
