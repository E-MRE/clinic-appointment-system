part of 'app_filter_chips.dart';

/// Visual values used by filter chips.
enum _FilterChipStyle {
  /// Style for an active filter chip.
  selected(tone: TextTone.onSecondaryContainer, weight: FontWeight.w600),

  /// Style for an inactive filter chip.
  unselected(tone: TextTone.normal, weight: FontWeight.w500);

  const _FilterChipStyle({required this.tone, required this.weight});

  /// Text tone for the chip label.
  final TextTone tone;

  /// Text weight for the chip label.
  final FontWeight weight;

  /// Resolves the style for the supplied selection state.
  factory _FilterChipStyle.fromSelected(bool selected) {
    return selected ? _FilterChipStyle.selected : _FilterChipStyle.unselected;
  }

  /// Background color for this chip style.
  Color background(ColorScheme scheme) {
    return switch (this) {
      _FilterChipStyle.selected => scheme.secondaryContainer,
      _FilterChipStyle.unselected => scheme.surface,
    };
  }
}
