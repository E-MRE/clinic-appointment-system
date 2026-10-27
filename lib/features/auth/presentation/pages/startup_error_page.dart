import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_brand_header.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/square_svg_icon.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/startup_error_kind.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

part 'startup_error_actions.dart';
part 'startup_error_icon.dart';

/// Recoverable session-startup failure using the approved shared error designs.
final class StartupErrorPage extends StatelessWidget {
  const StartupErrorPage({
    required this.kind,
    required this.onRetry,
    required this.onGoHome,
    this.onSignOut,
    super.key,
  });

  final StartupErrorKind kind;
  final VoidCallback onRetry;
  final VoidCallback onGoHome;
  final VoidCallback? onSignOut;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isMobile = context.screenSize.isMobile;
    final actions = _StartupErrorActions(
      kind: kind,
      isMobile: isMobile,
      onRetry: onRetry,
      onGoHome: onGoHome,
      onSignOut: onSignOut,
    );
    return AppScaffold(
      key: const WidgetKey.startupErrorPage(),
      child: Column(
        children: [
          AppBrandHeader(
            logo: Assets.images.brand.clinicLogo,
            logoSize: AppSizes.s32,
            minimumHeight: AppSizes.s48,
          ),
          Expanded(
            child: ErrorState(
              title: kind.titleKey.translate(),
              primaryAction: isMobile ? null : actions,
              message: kind.descriptionKey.translate(),
              icon: _StartupErrorIcon(kind: kind, isMobile: isMobile),
              iconBackground: kind.containerColor(colors),
              iconSize: context.screenSize.select(
                mobile: AppSizes.s96,
                tablet: AppSizes.illustrationLarge,
                desktop: AppSizes.illustrationLarge,
              ),
            ),
          ),
          if (isMobile)
            Padding(padding: const AppPadding.verticalSm(), child: actions),
        ],
      ),
    );
  }
}
