import 'package:clinic_appointment_system/core/widgets/checkbox_tile/app_checkbox_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('tile toggles and exposes checked semantics', (tester) async {
    bool selected = false;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => AppCheckboxTile(
              label: 'Service',
              value: selected,
              onChanged: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getSemantics(find.byType(AppCheckboxTile)),
      matchesSemantics(
        label: 'Service',
        hasCheckedState: true,
        isChecked: false,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    await tester.tap(find.text('Service'));
    await tester.pump();
    expect(selected, isTrue);
    expect(
      tester.getSemantics(find.byType(AppCheckboxTile)),
      matchesSemantics(
        label: 'Service',
        hasCheckedState: true,
        isChecked: true,
        hasEnabledState: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    semantics.dispose();
  });
  testWidgets('disabled tile ignores taps', (tester) async {
    bool called = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AppCheckboxTile(
            label: 'Service',
            value: true,
            enabled: false,
            onChanged: (_) => called = true,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Service'));
    expect(called, isFalse);
  });
}
