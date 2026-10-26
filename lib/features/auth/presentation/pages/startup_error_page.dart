import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
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
    required this.errorCode,
    required this.onRetry,
    required this.onGoHome,
    super.key,
  });

  final AuthErrorCode errorCode;
  final VoidCallback onRetry;
  final VoidCallback onGoHome;

  StartupErrorKind get _kind => StartupErrorKind.from(errorCode);

  @override
  Widget build(BuildContext context) {
    final kind = _kind;
    final colors = context.colorScheme;
    final isMobile = context.screenSize.isMobile;
    final actions = _StartupErrorActions(
      kind: kind,
      isMobile: isMobile,
      onRetry: onRetry,
      onGoHome: onGoHome,
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
              message: kind.descriptionKey.translate(),
              icon: _StartupErrorIcon(kind: kind, isMobile: isMobile),
              iconBackground: kind.containerColor(colors),
              iconSize: context.screenSize.select(
                mobile: AppSizes.s96,
                tablet: AppSizes.illustrationLarge,
                desktop: AppSizes.illustrationLarge,
              ),
              primaryAction: isMobile ? null : actions,
            ),
          ),
          if (isMobile)
            Padding(padding: const AppPadding.verticalSm(), child: actions),
        ],
      ),
    );
  }
}
