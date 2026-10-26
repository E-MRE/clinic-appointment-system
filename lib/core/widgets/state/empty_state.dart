import 'package:clinic_appointment_system/core/widgets/state/state_layout.dart';
import 'package:clinic_appointment_system/core/widgets/state/state_layout_variant.dart';

/// No-content presentation using the shared state layout.
final class EmptyState extends StateLayout {
  /// Creates an empty state from display values and an optional action.
  const EmptyState({
    required super.title,
    required super.message,
    required super.icon,
    required super.iconBackground,
    super.iconSize,
    super.primaryAction,
    super.secondaryAction,
    super.key,
  }) : super(variant: StateLayoutVariant.empty);
}
