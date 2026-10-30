part of 'app_navigation_shell.dart';

/// Selected and unselected visual decisions shared by every navigation tier.
enum _NavItemStyle {
  /// Style for the currently selected destination.
  selected(
    indicatorTone: TextTone.normal,
    sidebarTone: TextTone.onSecondaryContainer,
    weight: FontWeight.w600,
  ),

  /// Style for destinations that are not selected.
  unselected(
    indicatorTone: TextTone.muted,
    sidebarTone: TextTone.normal,
    weight: FontWeight.w500,
  );

  const _NavItemStyle({
    required this.indicatorTone,
    required this.sidebarTone,
    required this.weight,
  });

  /// Label tone under mobile and tablet indicators.
  final TextTone indicatorTone;

  /// Label tone inside the desktop sidebar row.
  final TextTone sidebarTone;

  /// Label weight for this state.
  final FontWeight weight;
}
