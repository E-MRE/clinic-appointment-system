import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_brand_header.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_destination.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

export 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_destination.dart';

part 'mobile_navigation.dart';
part 'mobile_navigation_item.dart';
part 'tablet_navigation.dart';
part 'tablet_navigation_item.dart';
part 'desktop_navigation.dart';
part 'desktop_navigation_item.dart';
part 'navigation_count_badge.dart';
part 'navigation_item_semantics.dart';
part 'navigation_item_style.dart';
part 'mobile_navigation_layout.dart';
part 'tablet_navigation_layout.dart';
part 'desktop_navigation_layout.dart';
part 'desktop_navigation_item_row.dart';
part 'mobile_navigation_indicator.dart';

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
      mobile: _MobileNavigationLayout(shell: this),
      tablet: _TabletNavigationLayout(shell: this),
      desktop: _DesktopNavigationLayout(shell: this),
    );
  }
}
