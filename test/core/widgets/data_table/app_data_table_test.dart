import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../support/widget_test_host.dart';

void main() {
  Widget table({AppTableDensity density = AppTableDensity.regular}) {
    return AppDataTable<String>(
      minWidth: 600,
      density: density,
      header: const Text('Toolbar'),
      footer: const Text('Footer'),
      rows: const ['First', 'Second'],
      columns: [
        AppTableColumn(
          label: 'Name',
          noWrap: true,
          cellBuilder: (context, row) => AppText.body(row),
        ),
        AppTableColumn(
          label: '',
          semanticsLabel: 'Actions',
          alignment: AppTableAlignment.end,
          cellBuilder: (context, row) => IconButton(
            onPressed: () {},
            tooltip: 'Edit $row',
            icon: const Icon(Icons.edit),
          ),
        ),
      ],
    );
  }

  for (final brightness in Brightness.values) {
    testWidgets('renders labels, cells and semantics in $brightness', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(widgetTestHost(table(), brightness: brightness));
      expect(find.text('Name'), findsOneWidget);
      expect(find.text('First'), findsOneWidget);
      expect(find.text('Second'), findsOneWidget);
      expect(find.bySemanticsLabel('Actions'), findsOneWidget);
      expect(
        tester
            .getSemantics(find.bySemanticsLabel('Name'))
            .flagsCollection
            .isHeader,
        isTrue,
      );
      expect(find.text('Toolbar'), findsOneWidget);
      expect(find.text('Footer'), findsOneWidget);
      handle.dispose();
    });
  }

  testWidgets('aligns columns, draws dividers and applies density', (
    tester,
  ) async {
    for (final density in AppTableDensity.values) {
      await tester.pumpWidget(widgetTestHost(table(density: density)));
      final renderTable = tester.widget<Table>(find.byType(Table));
      expect(renderTable.children.length, 3);
      for (final row in renderTable.children) {
        final decoration = row.decoration as BoxDecoration;
        expect(decoration.border?.top.width, AppSizes.borderThin);
      }
      final namePadding = tester.widget<Padding>(
        find
            .ancestor(of: find.text('Name'), matching: find.byType(Padding))
            .first,
      );
      expect(
        namePadding.padding,
        EdgeInsetsDirectional.only(
          start: density.outerPadding,
          end: density.middlePadding,
          top: AppSizes.s12,
          bottom: AppSizes.s12,
        ),
      );
      final actionAlign = tester.widget<Align>(
        find
            .ancestor(
              of: find.byTooltip('Edit First'),
              matching: find.byType(Align),
            )
            .first,
      );
      expect(actionAlign.alignment, AlignmentDirectional.centerEnd);
    }
  });

  testWidgets('scrolls horizontally on a narrow viewport', (tester) async {
    await tester.pumpWidget(
      widgetTestHost(
        Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 300, child: table()),
        ),
      ),
    );
    final scrollable = find.descendant(
      of: find.byType(AppDataTable<String>),
      matching: find.byType(Scrollable),
    );
    expect(
      tester.state<ScrollableState>(scrollable).position.maxScrollExtent,
      greaterThan(0),
    );
    await tester.drag(scrollable, const Offset(-300, 0));
    await tester.pumpAndSettle();
    expect(
      tester.state<ScrollableState>(scrollable).position.pixels,
      greaterThan(0),
    );
  });
}
