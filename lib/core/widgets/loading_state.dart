import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

part 'loading_skeleton_list.dart';
part 'loading_skeleton_card.dart';
part 'loading_skeleton_block.dart';
part 'loading_skeleton_line.dart';
part 'loading_centered_indicator.dart';

/// Loading presentation choices.
enum LoadingStateVariant {
  /// Placeholder list rows.
  skeletonList,

  /// Centered progress indicator.
  centeredIndicator,
}

/// Accessible loading content with either placeholder rows or an indicator.
final class LoadingState extends StatelessWidget {
  /// Creates loading content with a required translated semantics label.
  const LoadingState({required this.variant, required this.label, super.key});

  /// Loading presentation to display.
  final LoadingStateVariant variant;

  /// Localized label announced to assistive technology.
  final String label;

  @override
  Widget build(BuildContext context) {
    final content = switch (variant) {
      LoadingStateVariant.skeletonList => const _SkeletonList(),
      LoadingStateVariant.centeredIndicator => _CenteredIndicator(label: label),
    };
    return Semantics(
      liveRegion: true,
      label: label,
      child: ExcludeSemantics(child: content),
    );
  }
}

/// Width and height decisions for loading placeholders.
enum _SkeletonLineVariant {
  /// First heading placeholder.
  headingWide(0.55, AppSizes.s16),

  /// Second heading placeholder.
  headingShort(0.35, AppSizes.s16),

  /// Card title placeholder.
  title(0.7, AppSizes.s16),

  /// Metadata placeholder.
  metadata(0.45, AppSizes.s12),

  /// Long description placeholder.
  body(0.8, AppSizes.s12),

  /// Full width row placeholder.
  fullWidth(1, AppSizes.s12);

  const _SkeletonLineVariant(this.widthFactor, this.height);

  /// Relative width of the placeholder line.
  final double widthFactor;

  /// Height of the placeholder line.
  final double height;
}

/// Card content choices for skeleton rows.
enum _SkeletonCardVariant {
  /// Larger card with description and actions.
  featured(AppSizes.s48, AppRadius.medium(), true),

  /// Compact card with a circular avatar.
  compact(AppSizes.s40, AppRadius.full(), false);

  const _SkeletonCardVariant(
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
