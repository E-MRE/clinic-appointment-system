import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar_size.dart';
import 'package:flutter/material.dart';

export 'package:clinic_appointment_system/core/widgets/avatar/app_avatar_size.dart';

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
