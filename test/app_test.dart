import 'package:clinic_appointment_system/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the clinic appointment system title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Clinic Appointment System'), findsOneWidget);
  });
}
