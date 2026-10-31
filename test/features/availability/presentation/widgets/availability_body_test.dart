import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_button.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_segmented_control.dart';
import 'package:clinic_appointment_system/core/widgets/dashed_border/app_dashed_border.dart';
import 'package:clinic_appointment_system/core/widgets/date_field/app_date_field.dart';
import 'package:clinic_appointment_system/core/widgets/form_dialog/app_form_dialog.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/side_panel/app_side_panel.dart';
import 'package:clinic_appointment_system/core/widgets/time_field/app_time_field.dart';
import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_repeat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../pages/doubles/availability_page_harness.dart';

void main() {
  late AvailabilityPageHarness harness;
  setUp(() async {
    harness = AvailabilityPageHarness();
    await harness.initialize();
  });

  Future<void> load(WidgetTester tester, Size size, bool dark) async {
    addTearDown(() => harness.dispose(tester));
    final router = createAppRouter(initialLocation: AppRoutes.staffHome);
    addTearDown(router.dispose);
    await harness.pumpRouter(tester, router, size: size, dark: dark);
    await harness.load(
      tester,
      value: harness.loaded.withWeekly([
        AvailabilityPageHarness.fixture.weekly(540, 720),
        AvailabilityPageHarness.fixture.weekly(810, 990),
      ]),
    );
  }

  Future<void> pickTime(
    WidgetTester tester,
    String label,
    String hour, {
    String minute = '00',
  }) async {
    final field = find.byWidgetPredicate(
      (widget) => widget is AppTimeField && widget.label == label,
    );
    await tester.tap(
      find.descendant(of: field, matching: find.byType(InkWell)),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), hour);
    await tester.enterText(find.byType(TextField).at(1), minute);
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
  }

  Finder bars() => find.byWidgetPredicate(
    (widget) => widget.runtimeType.toString() == '_AvailabilityTimelineBar',
  );

  for (final dark in [false, true]) {
    testWidgets(
      'tablet timeline geometry, totals, closed days and footnote dark=$dark',
      (tester) async {
        await load(tester, AvailabilityPageHarness.tablet, dark);
        for (final tick in ['09:00', '11:00', '13:00', '15:00', '17:00']) {
          expect(find.text(tick), findsOneWidget);
        }
        expect(bars(), findsNWidgets(2));
        expect(
          tester.getCenter(find.text('09:00')).dx,
          closeTo(tester.getRect(bars().first).left, 1),
        );
        expect(find.text('09:00–12:00'), findsOneWidget);
        expect(find.text('13:30–16:30'), findsOneWidget);
        expect(find.text('6 saat'), findsOneWidget);
        expect(find.text('—'), findsWidgets);
        expect(find.text('Cumartesi'), findsOneWidget);
        expect(find.text('Şube kapalı'), findsNWidgets(2));
        expect(find.byType(AppDashedBorder), findsNWidgets(2));
        expect(
          find.text(
            'Açık zemin şubenin çalışma saatlerini (08:30–18:00) gösterir. Aralıklar bu saatlerin dışına taşamaz ve aynı gün içinde çakışamaz.',
          ),
          findsOneWidget,
        );
        expect(find.byType(AppAddButton), findsOneWidget);
        expect(find.byTooltip('Çarşamba aralıklarını düzenle'), findsNothing);
        expect(find.byType(AppSidePanel), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'tablet dialog retains overlap and closes after a successful save dark=$dark',
      (tester) async {
        await load(tester, AvailabilityPageHarness.tablet, dark);
        await harness.load(
          tester,
          value: harness.repository.current.withWeekly([
            ...harness.repository.current.weekly,
            AvailabilityPageHarness.fixture.weekly(
              540,
              720,
              day: Weekday.wednesday,
            ),
          ]),
        );
        await tester.tap(find.text('Aralık ekle'));
        await tester.pumpAndSettle();
        expect(find.byType(AppFormDialog), findsOneWidget);
        expect(
          find.byType(AppSegmentedControl<AvailabilityRepeat>),
          findsOneWidget,
        );
        await tester.tap(find.byType(DropdownButton<Weekday>));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Çarşamba').last);
        await tester.pumpAndSettle();
        await pickTime(tester, 'Başlangıç', '09');
        await pickTime(tester, 'Bitiş', '12');
        await tester.tap(find.text('Kaydet'));
        await harness.flush(tester);
        expect(find.byType(AppFormDialog), findsOneWidget);
        expect(
          find.text(
            'Bu aralık Çarşamba 09:00–12:00 ile çakışıyor. Mevcut aralığı genişletin ya da 12:00 sonrasını seçin.',
          ),
          findsOneWidget,
        );
        expect(
          tester
              .widgetList<AppTimeField>(find.byType(AppTimeField))
              .every((field) => field.hasError),
          isTrue,
        );
        expect(find.byType(SnackBar), findsNothing);
        await pickTime(tester, 'Bitiş', '16');
        await pickTime(tester, 'Başlangıç', '13');
        await tester.tap(find.text('Kaydet'));
        await harness.flush(tester);
        expect(find.byType(AppFormDialog), findsNothing);
        expect(harness.draft.state.start, isNull);
        expect(
          harness.repository.current.weeklyOn(Weekday.wednesday),
          hasLength(2),
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'tablet dated add opens the dialog with the date field dark=$dark',
      (tester) async {
        await load(tester, AvailabilityPageHarness.tablet, dark);
        await tester.ensureVisible(find.text('Tarih için aralık ekle'));
        await tester.ensureVisible(find.text('Tarih için aralık ekle'));
        await tester.tap(find.text('Tarih için aralık ekle'));
        await tester.pumpAndSettle();
        expect(find.byType(AppFormDialog), findsOneWidget);
        expect(find.byType(AppDateField), findsOneWidget);
        expect(find.byType(AppSelectField<Weekday>), findsNothing);
        await tester.tap(find.text('Vazgeç'));
        await tester.pumpAndSettle();
        expect(find.byType(AppFormDialog), findsNothing);
      },
    );

    testWidgets(
      'desktop panel selects weekday, draws pending range and counts slots dark=$dark',
      (tester) async {
        await load(tester, AvailabilityPageHarness.desktop, dark);
        expect(find.text('Aralık ekle'), findsOneWidget);
        expect(find.byType(AppSidePanel), findsOneWidget);
        expect(find.byType(AppNavigationUserCard), findsOneWidget);
        expect(find.text('Ada Kaya'), findsOneWidget);
        expect(
          find.byType(AppSegmentedControl<AvailabilityRepeat>),
          findsOneWidget,
        );
        expect(find.text('Aralığı kaydet'), findsOneWidget);
        expect(find.text('Haftalık aralıklar'), findsOneWidget);
        expect(find.text('Merkez Şube · 08:30–18:00'), findsOneWidget);
        final heading = find.byWidgetPredicate(
          (widget) =>
              widget.runtimeType.toString() == '_AvailabilityWeeklyHeading',
        );
        expect(
          tester.getRect(find.text('Merkez Şube · 08:30–18:00')).right,
          closeTo(tester.getRect(heading).right, 1),
        );
        await tester.tap(find.byTooltip('Çarşamba aralıklarını düzenle'));
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<AppSelectField<Weekday>>(
                find.byType(AppSelectField<Weekday>),
              )
              .value,
          Weekday.wednesday,
        );
        await pickTime(tester, 'Başlangıç', '13', minute: '30');
        await pickTime(tester, 'Bitiş', '16', minute: '30');
        expect(
          find.text(
            'Çarşamba 13:30–16:30 eklenecek. Hizmet sürenize göre 20 dakikalık 9 randevu saati açılır.',
          ),
          findsOneWidget,
        );
        final pending = find.byWidgetPredicate(
          (widget) => widget is AppDashedBorder && widget.strokeWidth == 2,
        );
        expect(pending, findsOneWidget);
        expect(bars(), findsNWidgets(3));
        expect(find.text('13:30–16:30'), findsNWidgets(2));
        // The unsaved range is aligned with the selected weekday's row.
        final row = tester.getRect(
          find.byTooltip('Çarşamba aralıklarını düzenle'),
        );
        expect(
          tester.getCenter(pending).dy >= row.top &&
              tester.getCenter(pending).dy <= row.bottom,
          isTrue,
        );
        await tester.tap(find.text('Aralığı kaydet'));
        await harness.flush(tester);
        expect(harness.draft.state.start, isNull);
        expect(pending, findsNothing);
        expect(
          harness.repository.current.weeklyOn(Weekday.wednesday),
          hasLength(1),
        );
        expect(find.text('Aralık ekle'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'desktop dated draft uses date weekday and retains repeat after saving dark=$dark',
      (tester) async {
        await load(tester, AvailabilityPageHarness.desktop, dark);
        await tester.tap(find.byTooltip('Çarşamba aralıklarını düzenle'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Belirli tarih'));
        await tester.pumpAndSettle();
        expect(find.byType(AppDateField), findsOneWidget);
        expect(find.byType(AppSelectField<Weekday>), findsNothing);
        harness.draft.selectDate(AvailabilityPageHarness.fixture.tuesday);
        harness.draft.changeStart(
          AvailabilityPageHarness.fixture.range(810, 990).start,
        );
        harness.draft.changeEnd(
          AvailabilityPageHarness.fixture.range(810, 990).end,
        );
        await tester.pumpAndSettle();
        final pending = find.byWidgetPredicate(
          (widget) => widget is AppDashedBorder && widget.strokeWidth == 2,
        );
        final row = tester.getRect(find.byTooltip('Salı aralıklarını düzenle'));
        expect(
          tester.getCenter(pending).dy >= row.top &&
              tester.getCenter(pending).dy <= row.bottom,
          isTrue,
        );
        await tester.tap(find.text('Aralığı kaydet'));
        await harness.flush(tester);
        expect(harness.draft.state.repeat, AvailabilityRepeat.oneOff);
        expect(harness.draft.state.start, isNull);
        expect(find.byType(AppDateField), findsOneWidget);
        expect(pending, findsNothing);
        expect(harness.repository.current.oneOff, hasLength(2));
      },
    );

    testWidgets(
      'desktop dated card lists and removes a one-off without opening a modal dark=$dark',
      (tester) async {
        await load(tester, AvailabilityPageHarness.desktop, dark);
        expect(find.text('2 Kasım Pazartesi · 16:30–17:30'), findsOneWidget);
        await tester.tap(find.byTooltip('Tek seferlik aralığı kaldır'));
        await harness.flush(tester);
        expect(harness.repository.current.oneOff, isEmpty);
        expect(find.text('Tek seferlik aralık yok.'), findsOneWidget);
        await tester.ensureVisible(find.text('Tarih için aralık ekle'));
        await tester.tap(find.text('Tarih için aralık ekle'));
        await tester.pumpAndSettle();
        expect(find.byType(AppDateField), findsOneWidget);
        expect(find.byType(AppFormDialog), findsNothing);
      },
    );

    testWidgets(
      'flagged timeline uses the error fill and warning semantics dark=$dark',
      (tester) async {
        await load(tester, AvailabilityPageHarness.desktop, dark);
        await harness.load(
          tester,
          value: harness.loaded.withWeekly([
            AvailabilityPageHarness.fixture.weekly(690, 810),
          ]),
        );
        final semantics = find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == '11:30–13:30 · Şube saatleri dışında',
        );
        expect(semantics, findsOneWidget);
        final bar = find
            .descendant(of: semantics, matching: find.byType(DecoratedBox))
            .first;
        final decoration =
            tester.widget<DecoratedBox>(bar).decoration as BoxDecoration;
        expect(
          decoration.color,
          Theme.of(tester.element(bar)).colorScheme.error,
        );
        expect(find.text('11:30–13:30'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'minimum desktop width keeps both columns reachable without overflow',
    (tester) async {
      await load(tester, const Size(840, 960), false);
      expect(tester.takeException(), isNull);
      await tester.ensureVisible(find.text('Aralığı kaydet'));
      expect(find.text('Aralığı kaydet').hitTestable(), findsOneWidget);
    },
  );

  testWidgets(
    'invalid panel draft removes pending bar and service failure omits slot counts',
    (tester) async {
      await load(tester, AvailabilityPageHarness.desktop, false);
      harness.draft.startWeekly(Weekday.wednesday);
      harness.draft.changeStart(
        AvailabilityPageHarness.fixture.range(810, 990).start,
      );
      harness.draft.changeEnd(
        AvailabilityPageHarness.fixture.range(810, 990).end,
      );
      await tester.pumpAndSettle();
      await tester.runAsync(() async {
        harness.serviceEvents.add(const DataResult.error());
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(find.text('Çarşamba 13:30–16:30 eklenecek.'), findsOneWidget);
      harness.draft.changeEnd(
        AvailabilityPageHarness.fixture.range(540, 720).end,
      );
      await tester.pumpAndSettle();
      expect(
        find.text('Bitiş saati başlangıçtan sonra olmalı.'),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (widget) => widget is AppDashedBorder && widget.strokeWidth == 2,
        ),
        findsNothing,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
