part of 'app_navigation_shell.dart';

/// Picks the [_NavItemStyle] for a selection state.
extension _NavItemStyleSelection on bool {
  /// The navigation item style for this selection state.
  _NavItemStyle get navItemStyle {
    if (this) return _NavItemStyle.selected;
    return _NavItemStyle.unselected;
  }
}
