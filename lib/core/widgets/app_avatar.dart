import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';

/// Initials avatar sizes used in shared list rows.
enum AppAvatarSize {
  /// 32 px compact avatar.
  small(AppSizes.s32, TextRole.badge),

  /// 40 px regular avatar.
  medium(AppSizes.s40, TextRole.label),

  /// 48 px prominent avatar.
  large(AppSizes.s48, TextRole.cardTitle);

  const AppAvatarSize(this.diameter, this.initialsRole);

  /// Avatar diameter in logical pixels.
  final double diameter;

  /// Text role supplying the scaled initials size.
  final TextRole initialsRole;
}

/// Circular initials avatar using the active tertiary theme colors.
final class AppAvatar extends StatelessWidget {
  /// Creates an avatar for the supplied display initials.
  const AppAvatar({
    required this.initials,
    this.size = AppAvatarSize.medium,
    super.key,
  });

  /// Text initials to display.
  final String initials;

  /// Avatar size variant.
  final AppAvatarSize size;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final initialsBase = size.initialsRole.resolve(context.textTheme);
    final style = TextRole.display
        .resolve(context.textTheme)
        ?.copyWith(
          fontSize: initialsBase?.fontSize,
          color: scheme.onTertiaryContainer,
        );
    return SizedBox.square(
      dimension: size.diameter,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.tertiaryContainer,
          borderRadius: const AppRadius.full(),
        ),
        child: Center(
          child: Text(initials, style: style, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
