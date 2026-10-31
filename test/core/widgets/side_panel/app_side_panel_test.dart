import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('layout shows panel only when requested', (tester) async {
    Widget layout(bool visible) => MaterialApp(
      home: Scaffold(
        body: AppSidePanelLayout(
          showsPanel: visible,
          panel: const AppSidePanel(child: Text('Panel')),
          child: const Text('Content'),
        ),
      ),
    );
    await tester.pumpWidget(layout(true));
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Panel'), findsOneWidget);
    await tester.pumpWidget(layout(false));
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Panel'), findsNothing);
  });
}
