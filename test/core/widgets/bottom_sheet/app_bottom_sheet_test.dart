import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_bottom_sheet_presentation.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_sheet_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../support/localization_test_app.dart';

void main() {
  testWidgets('sheet displays its content and action callbacks', (
    tester,
  ) async {
    bool cancelled = false;
    bool confirmed = false;
    await loadTestTranslations(
      tester,
      child: Scaffold(
        body: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                context.showAppBottomSheet<void>(
                  builder: (_) {
                    return AppBottomSheet(
                      title: 'Sheet',
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('Content'),
                          AppSheetActions(
                            cancelLabel: 'Cancel',
                            confirmLabel: 'Save',
                            onCancel: () {
                              cancelled = true;
                            },
                            onConfirm: () {
                              confirmed = true;
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Text('Open'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Sheet'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    await tester.tap(find.text('Cancel'));
    await tester.tap(find.text('Save'));
    expect(cancelled, isTrue);
    expect(confirmed, isTrue);
  });
  testWidgets('busy action disables confirm', (tester) async {
    await loadTestTranslations(
      tester,
      settle: false,
      child: Scaffold(
        body: AppSheetActions(
          cancelLabel: 'Cancel',
          confirmLabel: 'Save',
          onCancel: () {},
          onConfirm: () {},
          isBusy: true,
        ),
      ),
    );
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
