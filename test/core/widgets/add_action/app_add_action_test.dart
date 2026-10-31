import 'package:clinic_appointment_system/core/widgets/add_action/app_add_button.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_fab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets(
    'add actions invoke callbacks and button supports disabled state',
    (tester) async {
      int calls = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                AppAddButton(label: 'Add', onPressed: () => calls++),
                AppAddFab(label: 'Create', onPressed: () => calls++),
                const AppAddButton(label: 'Disabled'),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Add'));
      await tester.tap(find.text('Create'));
      await tester.tap(find.text('Disabled'));
      expect(calls, 2);
      expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Disabled'))
            .onPressed,
        isNull,
      );
    },
  );
}
