part of 'app_navigation_shell.dart';

/// Icons and colors that a [_NavItemStyle] picks for a destination.
extension _NavItemStyleResolution on _NavItemStyle {
  /// Whether this style marks the selected destination.
  bool get isSelected => this == _NavItemStyle.selected;

  /// Icon color for this state.
  Color iconColor(ColorScheme scheme) {
    return switch (this) {
      _NavItemStyle.selected => scheme.onSecondaryContainer,
      _NavItemStyle.unselected => scheme.onSurface,
    };
  }

  /// Indicator or row background; unselected items have none.
  Color? background(ColorScheme scheme) {
    return switch (this) {
      _NavItemStyle.selected => scheme.secondaryContainer,
      _NavItemStyle.unselected => null,
    };
  }

  /// The destination icon matching this state.
  IconData icon(AppNavigationDestination destination) {
    return switch (this) {
      _NavItemStyle.selected => destination.selectedIcon,
      _NavItemStyle.unselected => destination.icon,
    };
  }
}
