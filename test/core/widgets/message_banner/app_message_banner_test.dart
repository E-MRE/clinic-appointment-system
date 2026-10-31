import 'package:clinic_appointment_system/core/widgets/announced_semantics.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../support/localization_test_app.dart';

void main() {
  for (final variant in AppMessageBannerVariant.values) {
    testWidgets('$variant uses its scheme and announces errors', (
      tester,
    ) async {
      await loadTestTranslations(
        tester,
        child: Scaffold(
          body: AppMessageBanner(message: 'Message', variant: variant),
        ),
      );
      final scheme = Theme.of(
        tester.element(find.byType(AppMessageBanner)),
      ).colorScheme;
      final container = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(AppMessageBanner),
              matching: find.byType(Container),
            )
            .first,
      );
      final expected = switch (variant) {
        AppMessageBannerVariant.info => scheme.secondaryContainer,
        AppMessageBannerVariant.highlight => scheme.primaryContainer,
        AppMessageBannerVariant.error => scheme.errorContainer,
      };
      expect((container.decoration as BoxDecoration).color, expected);
      if (variant == AppMessageBannerVariant.error) {
        expect(find.byIcon(Icons.error_outline), findsOneWidget);
        expect(
          tester
              .widget<AnnouncedSemantics>(find.byType(AnnouncedSemantics))
              .liveRegion,
          isTrue,
        );
      }
    });
  }
}
