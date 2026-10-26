import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/viewport_scroll_view.dart';
import 'package:flutter/material.dart';

part 'state_icon.dart';

/// Shared layout algorithm for empty and error presentation states.
///
/// Subclasses provide the visual variant that differs between state types.
abstract class StateLayout extends StatelessWidget {
  /// Creates a shared state layout with display-only content.
  const StateLayout({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconBackground,
    required this.variant,
    this.iconSize = AppSizes.s96,
    this.primaryAction,
    this.secondaryAction,
    super.key,
  });

  /// State title shown as the page heading.
  final String title;

  /// Supporting message shown below the title.
  final String message;

  /// Decorative icon displayed in the state shape.
  final Widget icon;

  /// Background of the icon shape.
  final Color iconBackground;

  /// Size of the icon shape.
  final double iconSize;

  /// Optional main action.
  final Widget? primaryAction;

  /// Optional secondary action.
  final Widget? secondaryAction;

  /// Layout-specific shape and message rules subclasses must provide.
  final StateLayoutVariant variant;

  @override
  Widget build(BuildContext context) {
    final screenSize = context.screenSize;
    final messageWidth = variant.messageMaxWidth(screenSize);
    final messageRole = variant.messageRole(screenSize);
    return ViewportScrollView(
      child: Center(
        child: Padding(
          padding: const AppPadding.verticalXl(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StateIcon(
                icon: icon,
                background: iconBackground,
                size: iconSize,
                shape: variant.iconShape,
              ),
              const EmptySize.s24Height(),
              Semantics(
                liveRegion: true,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: messageWidth),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    spacing: AppSizes.s8,
                    children: [
                      Semantics(
                        header: true,
                        child: AppText.headline(
                          title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      AppText(
                        role: messageRole,
                        message,
                        tone: TextTone.muted,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
              if (primaryAction != null || secondaryAction != null) ...[
                const EmptySize.s24Height(),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: AppSizes.s12,
                  runSpacing: AppSizes.s8,
                  children: [?secondaryAction, ?primaryAction],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

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

/// Shape choices for the decorative state icon.
enum StateIconShape {
  /// Rounded square with the approved large radius.
  roundedSquare,

  /// Circular icon background.
  circle;

  /// Border radius matching this state icon shape.
  BorderRadius get radius {
    return switch (this) {
      roundedSquare => const AppRadius.xxLarge(),
      circle => const AppRadius.full(),
    };
  }
}
