import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_brand_header.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

part 'mobile_navigation.dart';
part 'mobile_navigation_item.dart';
part 'tablet_navigation.dart';
part 'tablet_navigation_item.dart';
part 'desktop_navigation.dart';
part 'desktop_navigation_item.dart';
part 'navigation_count_badge.dart';
part 'navigation_item_semantics.dart';

/// Data for one destination in a responsive navigation shell.
final class AppNavigationDestination {
  /// Creates a destination from display text and icon variants.
  const AppNavigationDestination({
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.badgeCount,
  });

  /// Visible destination label.
  final String label;

  /// Icon used when this destination is not selected.
  final IconData icon;

  /// Icon used when this destination is selected.
  final IconData selectedIcon;

  /// Optional count displayed with the destination.
  final int? badgeCount;
}

/// Responsive navigation shell for mobile, tablet and desktop layouts.
final class AppNavigationShell extends StatelessWidget {
  /// Creates navigation around the current page content.
  const AppNavigationShell({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.child,
    required this.logo,
    this.primaryAction,
    super.key,
  });

  /// Destinations are supplied by the caller; role-specific enums belong to role screens.
  final List<AppNavigationDestination> destinations;

  /// Index of the selected destination.
  final int selectedIndex;

  /// Called when another destination is chosen.
  final ValueChanged<int> onDestinationSelected;

  /// Current page content.
  final Widget child;

  /// Logo used in tablet and desktop navigation.
  final SvgGenImage logo;

  /// Optional desktop primary action.
  final Widget? primaryAction;

  @override
  Widget build(BuildContext context) {
    return context.screenSize.select(
      mobile: Scaffold(
        body: child,
        bottomNavigationBar: _MobileNavigation(
          destinations: destinations,
          selectedIndex: selectedIndex,
          onDestinationSelected: onDestinationSelected,
        ),
      ),
      tablet: Row(
        children: [
          _TabletNavigation(
            logo: logo,
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
          ),
          Expanded(child: child),
        ],
      ),
      desktop: Row(
        children: [
          _DesktopNavigation(
            logo: logo,
            destinations: destinations,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            primaryAction: primaryAction,
          ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

/// Selected and unselected visual decisions shared by every navigation tier.
enum _NavItemStyle {
  selected(TextTone.normal, TextTone.onSecondaryContainer),
  unselected(TextTone.muted, TextTone.normal);

  const _NavItemStyle(this.indicatorTone, this.sidebarTone);

  final TextTone indicatorTone;
  final TextTone sidebarTone;

  factory _NavItemStyle.fromSelected(bool selected) {
    return selected ? _NavItemStyle.selected : _NavItemStyle.unselected;
  }

  bool get isSelected {
    return this == _NavItemStyle.selected;
  }

  FontWeight get weight {
    return switch (this) {
      _NavItemStyle.selected => FontWeight.w600,
      _NavItemStyle.unselected => FontWeight.w500,
    };
  }

  Color iconColor(ColorScheme scheme) {
    return switch (this) {
      _NavItemStyle.selected => scheme.onSecondaryContainer,
      _NavItemStyle.unselected => scheme.onSurface,
    };
  }

  Color? background(ColorScheme scheme) {
    return switch (this) {
      _NavItemStyle.selected => scheme.secondaryContainer,
      _NavItemStyle.unselected => null,
    };
  }

  IconData icon(AppNavigationDestination destination) {
    return switch (this) {
      _NavItemStyle.selected => destination.selectedIcon,
      _NavItemStyle.unselected => destination.icon,
    };
  }
}
