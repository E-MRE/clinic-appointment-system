import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/working_hours_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../support/localization_test_app.dart';

void main() {
  testWidgets('editor updates its range through the shared time picker', (
    tester,
  ) async {
    final cubit = WorkingHoursEditorCubit();
    await loadTestTranslations(
      tester,
      child: BlocProvider.value(
        value: cubit,
        child: const Scaffold(
          body: SingleChildScrollView(child: WorkingHoursEditor()),
        ),
      ),
    );
    await tester.tap(find.text('09:00').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), '10');
    await tester.enterText(find.byType(TextField).at(1), '30');
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    expect(
      cubit.state.day(Weekday.monday).ranges.first.start,
      ClockTime(hour: 10, minute: 30),
    );
    await cubit.close();
  });
}
