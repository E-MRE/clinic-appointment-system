import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/state/state_icon_shape.dart';
import 'package:clinic_appointment_system/core/widgets/state/state_layout_variant.dart';
import 'package:clinic_appointment_system/core/widgets/viewport_scroll_view.dart';
import 'package:flutter/material.dart';

part 'state_icon.dart';
part 'state_message.dart';
part 'state_actions.dart';

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
              _StateMessage(
                title: title,
                message: message,
                maxWidth: variant.messageMaxWidth(screenSize),
                messageRole: variant.messageRole(screenSize),
              ),
              if (_hasActions) ...[
                const EmptySize.s24Height(),
                _StateActions(
                  primaryAction: primaryAction,
                  secondaryAction: secondaryAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  bool get _hasActions {
    return primaryAction != null || secondaryAction != null;
  }
}
