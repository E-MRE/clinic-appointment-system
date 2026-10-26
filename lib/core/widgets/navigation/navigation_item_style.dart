part of 'app_navigation_shell.dart';

/// Selected and unselected visual decisions shared by every navigation tier.
enum _NavItemStyle {
  /// Style for the currently selected destination.
  selected(
    isSelected: true,
    indicatorTone: TextTone.normal,
    sidebarTone: TextTone.onSecondaryContainer,
    weight: FontWeight.w600,
    hasBackground: true,
    usesSelectedIcon: true,
  ),

  /// Style for an unselected destination.
  unselected(
    isSelected: false,
    indicatorTone: TextTone.muted,
    sidebarTone: TextTone.normal,
    weight: FontWeight.w500,
    hasBackground: false,
    usesSelectedIcon: false,
  );

  const _NavItemStyle({
    required this.isSelected,
    required this.indicatorTone,
    required this.sidebarTone,
    required this.weight,
    required this.hasBackground,
    required this.usesSelectedIcon,
  });

  /// Whether this style represents the current destination.
  final bool isSelected;

  /// Text tone for the selected rail label.
  final TextTone indicatorTone;

  /// Text tone for the desktop sidebar label.
  final TextTone sidebarTone;

  /// Text weight for the destination label.
  final FontWeight weight;

  /// Whether the selected background is shown.
  final bool hasBackground;

  /// Whether the selected destination icon is used.
  final bool usesSelectedIcon;

  /// Resolves the style for the supplied selection state.
  factory _NavItemStyle.fromSelected(bool selected) {
    return selected ? _NavItemStyle.selected : _NavItemStyle.unselected;
  }

  /// Theme icon color for this destination.
  Color iconColor(ColorScheme scheme) {
    return switch (this) {
      _NavItemStyle.selected => scheme.onSecondaryContainer,
      _NavItemStyle.unselected => scheme.onSurface,
    };
  }

  /// Background color when this style has a selected background.
  Color? background(ColorScheme scheme) {
    if (hasBackground) {
      return scheme.secondaryContainer;
    }
    return null;
  }

  /// Destination icon selected by this style.
  IconData icon(AppNavigationDestination destination) {
    if (usesSelectedIcon) {
      return destination.selectedIcon;
    }
    return destination.icon;
  }
}
