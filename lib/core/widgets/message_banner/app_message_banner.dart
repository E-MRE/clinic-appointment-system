import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner_variant.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner_variant_colors.dart';
import 'package:flutter/material.dart';

export 'app_message_banner_variant.dart';

part 'app_message_banner_content.dart';

/// A themed informational or error message.
final class AppMessageBanner extends StatelessWidget {
  /// Creates a banner with an optional leading icon.
  const AppMessageBanner({
    required this.message,
    required this.variant,
    this.icon,
    super.key,
  });
  final String message;
  final AppMessageBannerVariant variant;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final content = _MessageBannerContent(
      message: message,
      variant: variant,
      icon: icon,
    );
    if (variant.isAnnounced) {
      return AnnouncedSemantics(label: message, child: content);
    }
    return content;
  }
}
