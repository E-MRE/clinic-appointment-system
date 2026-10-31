import 'package:clinic_appointment_system/core/widgets/state/app_muted_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders message', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: AppMutedMessage(message: 'Empty')),
      ),
    );
    expect(find.text('Empty'), findsOneWidget);
  });
}
