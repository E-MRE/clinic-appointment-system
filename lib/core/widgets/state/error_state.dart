import 'package:clinic_appointment_system/core/widgets/state/state_layout.dart';
import 'package:clinic_appointment_system/core/widgets/state/state_layout_variant.dart';

/// Recoverable failure presentation using the shared state layout.
final class ErrorState extends StateLayout {
  /// Creates an error state from display values and optional actions.
  const ErrorState({
    required super.title,
    required super.message,
    required super.icon,
    required super.iconBackground,
    super.iconSize,
    super.primaryAction,
    super.secondaryAction,
    super.key,
  }) : super(variant: StateLayoutVariant.error);
}
