import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge_variant.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge_variant_status.dart';
import 'package:flutter/material.dart';

part 'status_badge_content.dart';

/// A compact pill that pairs a display label with status or theme colors.
final class StatusBadge extends StatelessWidget {
  /// Creates a status badge with a translated display label.
  const StatusBadge({required this.label, required this.variant, super.key});

  /// Localized text displayed by the badge.
  final String label;

  /// Color and icon variant for the badge.
  final StatusBadgeVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final status = variant.appointmentStatus;
    final pair = status == null ? null : context.statusColors.resolve(status);
    final background = pair?.bg ?? _containerColor(colors);
    final foreground = pair?.fg ?? _contentColor(colors);
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.statusBadgeHeight),
      padding: const AppPadding.horizontalSm(),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const AppRadius.full(),
      ),
      child: _StatusBadgeContent(
        label: label,
        icon: variant.icon,
        foreground: foreground,
        style: context.textTheme.labelSmall?.copyWith(color: foreground),
      ),
    );
  }

  /// Background of the badges that do not show an appointment status.
  Color _containerColor(ColorScheme colors) {
    return switch (variant) {
      StatusBadgeVariant.info => colors.primaryContainer,
      _ => colors.surfaceContainerHigh,
    };
  }

  /// Foreground of the badges that do not show an appointment status.
  Color _contentColor(ColorScheme colors) {
    return switch (variant) {
      StatusBadgeVariant.info => colors.onPrimaryContainer,
      _ => colors.onSurfaceVariant,
    };
  }
}
