part of 'staff_management_page.dart';

/// Keeps creation available for both empty and populated loaded staff lists.
final class _StaffManagementDesktopLayout extends StatelessWidget {
  const _StaffManagementDesktopLayout({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StaffListCubit>().state;
    return AppSidePanelLayout(
      showsPanel:
          context.screenSize.isDesktop && state is InstitutionListLoaded<Staff>,
      panel: const AppSidePanel(child: _StaffManagementDesktopPanelBody()),
      child: child,
    );
  }
}
