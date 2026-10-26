import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Card content choices for skeleton rows.
enum LoadingSkeletonCardVariant {
  /// Larger card with description and actions.
  featured(AppSizes.s48, AppRadius.medium(), true),

  /// Compact card with a circular avatar.
  compact(AppSizes.s40, AppRadius.full(), false);

  const LoadingSkeletonCardVariant(
    this.avatarSize,
    this.avatarRadius,
    this.hasDetails,
  );

  /// Avatar dimensions for this card.
  final double avatarSize;

  /// Avatar shape for this card.
  final BorderRadius avatarRadius;

  /// Whether the card includes description and action placeholders.
  final bool hasDetails;
}
