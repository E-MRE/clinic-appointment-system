part of 'patient_shell.dart';

/// Desktop identity footer resolved from the signed-in patient's profile.
final class _PatientShellUserCard extends StatelessWidget {
  const _PatientShellUserCard();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AuthCubit>().state;
    if (state is AuthSignedIn) {
      return AppNavigationUserCard(
        initials: state.user.initials,
        name: state.user.fullName,
        subtitle: LocaleKeys.roles_patient.translate(),
        signOutTooltip: LocaleKeys.patient_signOut.translate(),
        onSignOut: context.read<AuthCubit>().signOut,
      );
    }
    return const SizedBox.shrink();
  }
}
