import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/state/state_icon_shape.dart';

/// Shape, message width, and body role for a state layout.
enum StateLayoutVariant {
  /// Error screens use a rounded square icon and wider desktop copy.
  error,

  /// Empty screens use a circular icon and narrower copy.
  empty;

  /// Icon shape used for this state.
  StateIconShape get iconShape {
    return switch (this) {
      error => StateIconShape.roundedSquare,
      empty => StateIconShape.circle,
    };
  }

  /// Maximum message width for the active screen tier.
  double messageMaxWidth(ScreenSize size) {
    return switch (this) {
      error => size.select(
        mobile: double.infinity,
        tablet: AppSizes.errorMessageTabletWidth,
        desktop: AppSizes.messageMaxWidth,
      ),
      empty => size.select(
        mobile: AppSizes.emptyMessageMobileWidth,
        tablet: AppSizes.emptyMessageTabletWidth,
        desktop: AppSizes.emptyMessageTabletWidth,
      ),
    };
  }

  /// Semantic body role for this state and screen tier.
  TextRole messageRole(ScreenSize size) {
    return switch (this) {
      error => size.select(
        mobile: TextRole.bodyLarge,
        tablet: TextRole.bodyLarge,
        desktop: TextRole.bodyLarge,
      ),
      empty => TextRole.body,
    };
  }
}
