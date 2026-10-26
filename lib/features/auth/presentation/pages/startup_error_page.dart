import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_brand_header.dart';
import 'package:clinic_appointment_system/core/widgets/app_scaffold.dart';
import 'package:clinic_appointment_system/core/widgets/square_svg_icon.dart';
import 'package:clinic_appointment_system/core/widgets/viewport_scroll_view.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/startup_error_kind.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

part 'startup_error_badge.dart';
part 'startup_error_message.dart';
part 'startup_error_actions.dart';

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
    final isMobile = context.screenSize.isMobile;
    final actions = _StartupErrorActions(
      kind: _kind,
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
          Expanded(child: _buildScrollView(isMobile, actions)),
          if (isMobile)
            Padding(padding: const AppPadding.verticalSm(), child: actions),
        ],
      ),
    );
  }

  ViewportScrollView _buildScrollView(
    bool isMobile,
    _StartupErrorActions actions,
  ) {
    return ViewportScrollView(
      child: Center(
        child: Padding(
          padding: const AppPadding.verticalXl(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StartupErrorBadge(kind: _kind),
              const EmptySize.s24Height(),
              _StartupErrorMessage(kind: _kind),
              if (!isMobile) ...[const EmptySize.s24Height(), actions],
            ],
          ),
        ),
      ),
    );
  }
}
