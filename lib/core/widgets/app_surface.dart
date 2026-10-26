import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Shape and emphasis options for [AppSurface].
enum AppSurfaceVariant {
  /// Standard surface using the low surface container.
  standard,

  /// Highlighted surface using the primary container.
  highlighted,
}

/// Preset corner radii for a card or panel surface.
enum AppSurfaceRadius {
  /// Card radius = 12.
  card(AppRadius.medium()),

  /// Panel radius = 16.
  panel(AppRadius.large());

  const AppSurfaceRadius(this.value);

  /// Radius used by this surface.
  final BorderRadius value;
}

/// Preset inner spacing for a surface.
enum AppSurfacePadding {
  /// Padding = 16.
  compact(AppPadding.allLg()),

  /// Padding = 20.
  comfortable(AppPadding.all20()),

  /// Padding = 24.
  spacious(AppPadding.allXl());

  const AppSurfacePadding(this.value);

  /// Inner padding preset for this surface variant.
  final AppPadding value;
}

/// A themed, bordered container for shared cards and panels.
final class AppSurface extends StatelessWidget {
  const AppSurface({
    required this.child,
    this.variant = AppSurfaceVariant.standard,
    this.radius = AppSurfaceRadius.card,
    this.padding = AppSurfacePadding.compact,
    super.key,
  });

  final Widget child;
  final AppSurfaceVariant variant;
  final AppSurfaceRadius radius;
  final AppSurfacePadding padding;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final highlighted = variant == AppSurfaceVariant.highlighted;
    return Container(
      padding: padding.value,
      decoration: BoxDecoration(
        color: highlighted
            ? colors.primaryContainer
            : colors.surfaceContainerLow,
        borderRadius: radius.value,
        border: Border.all(
          color: highlighted ? colors.primary : colors.outlineVariant,
          width: highlighted ? AppSizes.borderThick : AppSizes.borderThin,
        ),
      ),
      child: child,
    );
  }
}
