part of 'staff_shell.dart';

/// Desktop identity footer resolved from the current authenticated profile.
final class _StaffShellUserCard extends StatelessWidget {
  const _StaffShellUserCard();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    if (state case AuthSignedIn(:final user)) {
      final staff = user.staffProfile;
      if (staff != null) {
        return AppNavigationUserCard(
          initials: staff.initials,
          name: staff.fullName,
          subtitle: staff.accept(const StaffRoleSubtitleVisitor()),
          signOutTooltip: LocaleKeys.availability_signOut.translate(),
          onSignOut: context.read<AuthCubit>().signOut,
        );
      }
    }
    return const SizedBox.shrink();
  }
}
