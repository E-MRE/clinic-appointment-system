import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_radius.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/widget_test_host.dart';

void main() {
  testWidgets('applies zero padding and optional clipping', (tester) async {
    await tester.pumpWidget(
      widgetTestHost(
        const Column(
          children: [
            AppSurface(child: Text('default')),
            AppSurface(
              padding: AppSurfacePadding.none,
              clipBehavior: Clip.antiAlias,
              child: Text('clipped'),
            ),
          ],
        ),
      ),
    );

    Container containerFor(String label) {
      final surface = find.ancestor(
        of: find.text(label),
        matching: find.byType(AppSurface),
      );
      return tester.widget<Container>(
        find.descendant(of: surface, matching: find.byType(Container)).first,
      );
    }

    expect(containerFor('default').clipBehavior, Clip.none);
    expect(containerFor('clipped').clipBehavior, Clip.antiAlias);
    expect(containerFor('clipped').padding, EdgeInsets.zero);
  });

  testWidgets('renders every variant in dark theme at text scale 2', (
    tester,
  ) async {
    await tester.pumpWidget(
      widgetTestHost(
        const Wrap(
          children: [
            AppSurface(child: Text('card')),
            AppSurface(radius: AppSurfaceRadius.panel, child: Text('panel')),
            AppSurface(
              padding: AppSurfacePadding.comfortable,
              child: Text('20'),
            ),
            AppSurface(padding: AppSurfacePadding.spacious, child: Text('24')),
            AppSurface(
              variant: AppSurfaceVariant.highlighted,
              child: Text('highlighted'),
            ),
          ],
        ),
        brightness: Brightness.dark,
        textScale: 2,
      ),
    );
    expect(find.text('highlighted'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
