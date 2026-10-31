import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:flutter/material.dart';

part 'navigation_user_card_avatar.dart';
part 'navigation_user_card_identity.dart';

/// Desktop sidebar identity and sign-out action.
final class AppNavigationUserCard extends StatelessWidget {
  /// Creates a user card with an accessible sign-out action.
  const AppNavigationUserCard({
    required this.initials,
    required this.name,
    required this.subtitle,
    required this.signOutTooltip,
    required this.onSignOut,
    super.key,
  });
  final String initials;
  final String name;
  final String subtitle;
  final String signOutTooltip;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      padding: const AppPadding.allMd(),
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: const AppRadius.medium(),
      ),
      child: Row(
        spacing: AppSizes.s12,
        children: [
          _NavigationUserCardAvatar(initials: initials),
          Expanded(
            child: _NavigationUserCardIdentity(name: name, subtitle: subtitle),
          ),
          SizedBox.square(
            dimension: AppSizes.s40,
            child: IconButton(
              onPressed: onSignOut,
              tooltip: signOutTooltip,
              icon: const Icon(Icons.logout, size: AppSizes.s20),
            ),
          ),
        ],
      ),
    );
  }
}
