part of 'app_segmented_control.dart';

/// Visual values used by segmented controls.
enum _SegmentStyle {
  /// Style for the active segment.
  selected(tone: TextTone.onSecondaryContainer, weight: FontWeight.w600),

  /// Style for an inactive segment.
  unselected(tone: TextTone.normal, weight: FontWeight.w500);

  const _SegmentStyle({required this.tone, required this.weight});

  /// Text tone for the segment label.
  final TextTone tone;

  /// Text weight for the segment label.
  final FontWeight weight;

  /// Resolves the style for the supplied selection state.
  factory _SegmentStyle.fromSelected(bool selected) {
    return selected ? _SegmentStyle.selected : _SegmentStyle.unselected;
  }

  /// Background color for this segment style.
  Color background(ColorScheme scheme) {
    return switch (this) {
      _SegmentStyle.selected => scheme.secondaryContainer,
      _SegmentStyle.unselected => scheme.surface,
    };
  }
}
