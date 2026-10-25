import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/startup_error_page.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  for (final base in [
    LightTheme(ScreenSize.mobile).themeData,
    DarkTheme(ScreenSize.mobile).themeData,
  ]) {
    for (final offline in [true, false]) {
      testWidgets(
        'startup icons follow overridden ${base.brightness.name} colors (offline: $offline)',
        (tester) async {
          final colors = base.colorScheme.copyWith(
            secondaryContainer: base.colorScheme.tertiaryContainer,
            onSecondaryContainer: base.colorScheme.onTertiaryContainer,
            errorContainer: base.colorScheme.primaryContainer,
            onErrorContainer: base.colorScheme.onPrimaryContainer,
          );
          await loadTestTranslations(
            tester,
            theme: base.copyWith(colorScheme: colors),
            child: StartupErrorPage(
              errorCode: offline
                  ? AuthErrorCode.networkRequestFailed
                  : AuthErrorCode.unexpected,
              onRetry: () {},
              onGoHome: () {},
            ),
          );
          final asset = offline
              ? Assets.images.status.offline.path
              : Assets.images.status.error.path;
          final iconFinder = find.byWidgetPredicate(
            (widget) =>
                widget is SvgPicture &&
                (widget.bytesLoader as SvgAssetLoader).assetName == asset,
          );
          final icon = tester.widget<SvgPicture>(iconFinder);
          expect(
            icon.colorFilter,
            ColorFilter.mode(
              offline ? colors.onSecondaryContainer : colors.onErrorContainer,
              BlendMode.srcIn,
            ),
          );
          final container = tester.widget<Container>(
            find
                .ancestor(of: iconFinder, matching: find.byType(Container))
                .first,
          );
          expect(
            (container.decoration! as BoxDecoration).color,
            offline ? colors.secondaryContainer : colors.errorContainer,
          );
          final retryIcon = tester.widget<SvgPicture>(
            find.byWidgetPredicate(
              (widget) =>
                  widget is SvgPicture &&
                  (widget.bytesLoader as SvgAssetLoader).assetName ==
                      Assets.images.status.retry.path,
            ),
          );
          expect(
            retryIcon.colorFilter,
            ColorFilter.mode(colors.onPrimary, BlendMode.srcIn),
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
