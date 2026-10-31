import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A selectable full-width tile with a checkbox and label.
final class AppCheckboxTile extends StatelessWidget {
  /// Creates a checkbox tile.
  const AppCheckboxTile({
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    super.key,
  });

  /// Text identifying the selection.
  final String label;

  /// Current checked state.
  final bool value;

  /// Called with the toggled state when activated.
  final ValueChanged<bool> onChanged;

  /// Whether the tile can be activated.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      checked: value,
      enabled: enabled,
      onTap: _onTap,
      excludeSemantics: true,
      child: Material(
        color: _background(context.colorScheme),
        shape: RoundedRectangleBorder(
          borderRadius: const AppRadius.medium(),
          side: _border(context.colorScheme),
        ),
        child: InkWell(
          borderRadius: const AppRadius.medium(),
          onTap: _onTap,
          child: Row(
            children: [
              Checkbox(value: value, onChanged: _onCheckboxChanged),
              Expanded(child: _label),
            ],
          ),
        ),
      ),
    );
  }

  VoidCallback? get _onTap => enabled ? _toggle : null;

  ValueChanged<bool?>? get _onCheckboxChanged => enabled ? _check : null;

  TextTone get _tone => enabled ? TextTone.normal : TextTone.muted;

  Widget get _label {
    if (value) {
      return AppText.bodyStrong(label, tone: _tone);
    }
    return AppText.body(label, tone: _tone);
  }

  void _toggle() => onChanged(!value);

  void _check(bool? checked) {
    if (checked != null) onChanged(checked);
  }

  Color _background(ColorScheme scheme) {
    if (!value) return scheme.surface;
    if (enabled) return scheme.secondaryContainer;
    return scheme.surfaceContainerHighest;
  }

  BorderSide _border(ColorScheme scheme) {
    if (value) return BorderSide.none;
    return BorderSide(color: scheme.outlineVariant);
  }
}
