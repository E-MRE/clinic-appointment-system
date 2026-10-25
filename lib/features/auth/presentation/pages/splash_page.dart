import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/system_overlay_region.dart';
import 'package:clinic_appointment_system/core/widgets/viewport_scroll_view.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';

part 'splash_brand.dart';
part 'splash_centered_layout.dart';
part 'splash_compact_layout.dart';
part 'splash_progress.dart';

/// The Flutter Splash shown while the persisted session is being restored.
final class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final background = context.colorScheme.primary;
    return SystemOverlayRegion(
      background: background,
      child: Scaffold(
        key: const WidgetKey.splashPage(),
        backgroundColor: background,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) =>
                _isCompact(context, constraints.maxHeight)
                ? const _SplashCompactLayout()
                : const _SplashCenteredLayout(),
          ),
        ),
      ),
    );
  }

  /// Short viewports and large text scroll instead of pinning the progress.
  bool _isCompact(BuildContext context, double height) =>
      height < Breakpoints.compactHeight ||
      context.textScaleFor(context.textTheme.headlineLarge!.fontSize!) >
          Breakpoints.largeTextScale;
}
