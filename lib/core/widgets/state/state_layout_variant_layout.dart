import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/state/state_icon_shape.dart';
import 'package:clinic_appointment_system/core/widgets/state/state_layout_variant.dart';

/// Icon shape and message layout of a [StateLayoutVariant].
extension StateLayoutVariantLayout on StateLayoutVariant {
  /// Icon shape used for this state.
  StateIconShape get iconShape {
    return switch (this) {
      StateLayoutVariant.error => StateIconShape.roundedSquare,
      StateLayoutVariant.empty => StateIconShape.circle,
    };
  }

  /// Maximum message width for the active screen tier.
  double messageMaxWidth(ScreenSize size) {
    return switch (this) {
      StateLayoutVariant.error => size.select(
        mobile: double.infinity,
        tablet: AppSizes.errorMessageTabletWidth,
        desktop: AppSizes.messageMaxWidth,
      ),
      StateLayoutVariant.empty => size.select(
        mobile: AppSizes.emptyMessageMobileWidth,
        tablet: AppSizes.emptyMessageTabletWidth,
        desktop: AppSizes.emptyMessageTabletWidth,
      ),
    };
  }

  /// Semantic body role for this state and screen tier.
  TextRole messageRole(ScreenSize size) {
    return switch (this) {
      StateLayoutVariant.error => size.select(
        mobile: TextRole.bodyLarge,
        tablet: TextRole.bodyLarge,
        desktop: TextRole.bodyLarge,
      ),
      StateLayoutVariant.empty => TextRole.body,
    };
  }
}
