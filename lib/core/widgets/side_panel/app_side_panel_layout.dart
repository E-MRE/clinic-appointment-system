import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Places content beside an optional side panel.
final class AppSidePanelLayout extends StatelessWidget {
  /// Creates a panel layout.
  const AppSidePanelLayout({
    required this.child,
    required this.panel,
    required this.showsPanel,
    super.key,
  });

  /// Main content.
  final Widget child;

  /// Panel shown beside the content.
  final Widget panel;

  /// Whether the panel is visible.
  final bool showsPanel;

  @override
  Widget build(BuildContext context) {
    if (showsPanel) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: AppSizes.s16,
        children: [
          Expanded(child: child),
          panel,
        ],
      );
    }
    return child;
  }
}
