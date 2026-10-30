import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_skeleton_card_variant.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_skeleton_line_variant.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state_variant.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:flutter/material.dart';

part 'loading_skeleton_list.dart';
part 'loading_skeleton_card.dart';
part 'loading_skeleton_card_header.dart';
part 'loading_skeleton_card_details.dart';
part 'loading_skeleton_block.dart';
part 'loading_skeleton_line.dart';
part 'loading_centered_indicator.dart';

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
