part of 'staff_shell.dart';

/// Navigation layout displaying live destination badges and routed content.
final class _StaffShellContent extends StatelessWidget {
  const _StaffShellContent({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final destination = GoRouterState.of(context).uri.path.staffDestination;
    final pendingCount = context
        .watch<StaffAppointmentsCubit>()
        .state
        .pendingRequests
        .length;

    return AppNavigationShell(
      logo: Assets.images.brand.clinicLogo,
      selectedIndex: destination.index,
      onDestinationSelected: (index) {
        context.go(StaffDestination.values[index].route);
      },
      destinations: [
        for (final item in StaffDestination.values)
          item.destination(badgeCount: _badgeCount(item, pendingCount)),
      ],
      footer: const _StaffShellUserCard(),
      child: child,
    );
  }

  /// The pending count on Talepler; no badge elsewhere or at zero.
  int? _badgeCount(StaffDestination item, int pendingCount) {
    if (item != StaffDestination.requests || pendingCount == 0) return null;
    return pendingCount;
  }
}
