part of 'app_segmented_control.dart';

/// One selectable segment.
final class _Segment<T> extends StatelessWidget {
  const _Segment({
    required this.choice,
    required this.selected,
    required this.enabled,
    required this.onSelected,
  });

  final AppChoice<T> choice;
  final bool selected;
  final bool enabled;
  final ValueChanged<T> onSelected;

  /// Opacity applied to the whole segment while interaction is disabled.
  double get _disabledOpacity => 0.6;

  /// Selects this segment, or null so the ink well ignores taps when disabled.
  VoidCallback? get _onTap {
    if (!enabled) return null;
    return () => onSelected(choice.value);
  }

  @override
  Widget build(BuildContext context) {
    final style = _SegmentStyle.fromSelected(selected);
    final content = Material(
      color: style.background(context.colorScheme),
      borderRadius: const AppRadius.full(),
      child: InkWell(
        onTap: _onTap,
        borderRadius: const AppRadius.full(),
        child: _SegmentLabel(label: choice.label, style: style),
      ),
    );

    if (enabled) return content;
    return Opacity(opacity: _disabledOpacity, child: content);
  }
}
