import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:flutter/material.dart';

/// A fixed-width scrollable side panel.
final class AppSidePanel extends StatelessWidget {
  /// Creates a side panel.
  const AppSidePanel({required this.child, super.key});

  /// Content displayed inside the panel.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.sidePanelWidth,
      child: AppSurface(
        padding: AppSurfacePadding.compact,
        child: SingleChildScrollView(child: child),
      ),
    );
  }
}
