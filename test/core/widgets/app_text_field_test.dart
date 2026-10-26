import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/core/theme/dark_theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('supports disabled, obscured, autofill and input action states', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    final controller = TextEditingController(text: 'secret');
    var obscured = true;
    await tester.pumpWidget(
      MaterialApp(
        theme: DarkTheme(ScreenSize.mobile).themeData,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: StatefulBuilder(
            builder: (context, setState) => Scaffold(
              body: Column(
                children: [
                  AppTextField(
                    label: 'Password',
                    controller: controller,
                    obscureText: obscured,
                    autofillHints: const [AutofillHints.password],
                    textInputAction: TextInputAction.done,
                    suffix: IconButton(
                      onPressed: () {
                        setState(() {
                          obscured = !obscured;
                        });
                      },
                      icon: const Icon(Icons.visibility),
                    ),
                  ),
                  AppTextField(
                    label: 'Disabled',
                    controller: controller,
                    enabled: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final field = tester.widget<EditableText>(find.byType(EditableText).first);
    expect(field.obscureText, isTrue);
    expect(field.autofillHints, [AutofillHints.password]);
    expect(field.textInputAction, TextInputAction.done);
    expect(
      tester
          .widget<EditableText>(find.byType(EditableText).last)
          .focusNode
          .canRequestFocus,
      isFalse,
    );
    await tester.tap(find.byIcon(Icons.visibility));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText).first).obscureText,
      isFalse,
    );
    expect(tester.takeException(), isNull);
    controller.dispose();
  });
}
