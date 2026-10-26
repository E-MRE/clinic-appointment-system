import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Appointment and informational badge appearances.
enum StatusBadgeVariant {
  /// Appointment is waiting for a decision.
  pending(Icons.schedule),

  /// Appointment is approved.
  approved(Icons.check_circle_outline),

  /// Appointment was rejected.
  rejected(Icons.cancel_outlined),

  /// Appointment was completed.
  completed(Icons.check_circle),

  /// Patient did not attend.
  noShow(Icons.person_off_outlined),

  /// Appointment was cancelled.
  cancelled(Icons.block_outlined),

  /// Neutral count or contextual badge.
  neutral(null),

  /// Informational count badge.
  info(null);

  const StatusBadgeVariant(this.icon);

  /// Leading icon; count badges have none.
  final IconData? icon;

  /// Appointment status represented by this variant, if any.
  AppointmentStatus? get appointmentStatus {
    return switch (this) {
      pending => AppointmentStatus.pending,
      approved => AppointmentStatus.approved,
      rejected => AppointmentStatus.rejected,
      completed => AppointmentStatus.completed,
      noShow => AppointmentStatus.noShow,
      cancelled => AppointmentStatus.cancelled,
      neutral || info => null,
    };
  }
}

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
    final badgeStyle = context.textTheme.labelSmall?.copyWith(
      color: foreground,
    );
    return Container(
      constraints: const BoxConstraints(minHeight: AppSizes.statusBadgeHeight),
      padding: const AppPadding.horizontalSm(),
      decoration: BoxDecoration(
        color: background,
        borderRadius: const AppRadius.full(),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (variant.icon case final icon?) ...[
            Icon(icon, size: AppSizes.statusIcon, color: foreground),
            const EmptySize.s4Width(),
          ],
          Text(label, style: badgeStyle),
        ],
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
