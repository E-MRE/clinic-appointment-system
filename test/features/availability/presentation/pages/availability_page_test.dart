import 'dart:async';

import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:clinic_appointment_system/core/widgets/date_field/app_date_field.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/state/error_state.dart';
import 'package:clinic_appointment_system/core/widgets/time_field/app_time_field.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/presentation/pages/availability_page.dart';
import 'package:clinic_appointment_system/features/availability/presentation/widgets/availability_body.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'doubles/availability_page_harness.dart';

void main() {
  late AvailabilityPageHarness harness;

  setUp(() async {
    harness = AvailabilityPageHarness();
    await harness.initialize();
  });

  Future<void> openWednesday(WidgetTester tester) async {
    await tester.ensureVisible(find.byTooltip('Çarşamba için aralık ekle'));
    await tester.tap(find.byTooltip('Çarşamba için aralık ekle'));
    await tester.pumpAndSettle();
    expect(find.text('Çarşamba · aralık ekle'), findsOneWidget);
    expect(find.byType(AppSelectField<Weekday>), findsNothing);
  }

  Future<void> pickTime(WidgetTester tester, String label, String hour) async {
    final field = find.byWidgetPredicate(
      (widget) => widget is AppTimeField && widget.label == label,
    );
    await tester.tap(
      find.descendant(of: field, matching: find.byType(InkWell)),
    );
    await tester.pumpAndSettle();
    expect(find.byType(TimePickerDialog), findsOneWidget);
    await tester.tap(find.byIcon(Icons.keyboard_outlined));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), hour);
    await tester.enterText(find.byType(TextField).at(1), '00');
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
  }

  for (final dark in [false, true]) {
    testWidgets(
      'loaded mobile weekly rows, dated item and branch banner dark=$dark',
      (tester) async {
        addTearDown(() => harness.dispose(tester));
        await harness.pump(tester, const AvailabilityPage(), dark: dark);
        await harness.load(tester);
        expect(find.byType(AppTimeRangeChip), findsNWidgets(2));
        expect(find.text('09:00–10:00'), findsOneWidget);
        expect(find.text('13:00–14:00'), findsOneWidget);
        expect(find.text('Şube kapalı'), findsNWidgets(2));
        expect(find.byTooltip('Cumartesi için aralık ekle'), findsNothing);
        expect(find.byTooltip('Pazartesi için aralık ekle'), findsOneWidget);
        expect(find.byIcon(Icons.apartment_outlined), findsOneWidget);
        expect(
          find.text(
            'Merkez Şube çalışma saatleri: Pzt–Cum 08:30–12:00, 13:00–18:00 · Cmt, Paz kapalı.',
          ),
          findsOneWidget,
        );
        await tester.ensureVisible(
          find.text('2 Kasım Pazartesi · 16:30–17:30'),
        );
        expect(
          find.text('Yalnızca bu tarih için, haftalık aralığa eklenir'),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'empty body has add actions only for open days and dated empty message',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(
        tester,
        AvailabilityBody(staff: harness.staff, header: const SizedBox.shrink()),
      );
      await harness.load(tester, value: AvailabilityPageHarness.fixture.empty);
      expect(find.byType(AppTimeRangeChip), findsNothing);
      for (final day in ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma']) {
        expect(find.byTooltip('$day için aralık ekle'), findsOneWidget);
      }
      expect(find.byTooltip('Cumartesi için aralık ekle'), findsNothing);
      expect(find.byTooltip('Pazar için aralık ekle'), findsNothing);
      await tester.ensureVisible(find.text('Tek seferlik aralık yok.'));
      expect(find.text('Tek seferlik aralık yok.'), findsOneWidget);
    },
  );

  testWidgets(
    'overlap retains sheet, conflict guidance and invalid time borders',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const AvailabilityPage());
      await harness.load(
        tester,
        value: harness.loaded.withWeekly([
          AvailabilityPageHarness.fixture.weekly(
            600,
            660,
            day: Weekday.wednesday,
          ),
        ]),
      );
      await openWednesday(tester);
      await pickTime(tester, 'Başlangıç', '09');
      await pickTime(tester, 'Bitiş', '12');
      await tester.tap(find.text('Kaydet'));
      await harness.flush(tester);
      expect(find.byType(AppBottomSheet), findsOneWidget);
      const conflict =
          'Bu aralık Çarşamba 10:00–11:00 ile çakışıyor. Mevcut aralığı genişletin ya da 11:00 sonrasını seçin.';
      expect(find.text(conflict), findsOneWidget);
      expect(
        tester
            .widgetList<AppTimeField>(find.byType(AppTimeField))
            .every((field) => field.hasError),
        isTrue,
      );
      final errorBanner = find.byWidgetPredicate(
        (widget) =>
            widget is AppMessageBanner &&
            widget.variant == AppMessageBannerVariant.error,
      );
      expect(errorBanner, findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
      expect(harness.repository.updateCalls, 1);
    },
  );

  testWidgets(
    'successful add closes sheet, resets draft and updates the watched schedule',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const AvailabilityPage());
      await harness.load(tester);
      await openWednesday(tester);
      await pickTime(tester, 'Başlangıç', '09');
      await pickTime(tester, 'Bitiş', '12');
      await tester.tap(find.text('Kaydet'));
      await harness.flush(tester);
      expect(find.byType(AppBottomSheet), findsNothing);
      expect(harness.repository.current.weeklyOn(Weekday.wednesday), [
        AvailabilityPageHarness.fixture.weekly(
          540,
          720,
          day: Weekday.wednesday,
        ),
      ]);
      expect(harness.draft.state.start, isNull);
      expect(harness.draft.state.end, isNull);
      expect(find.byType(AppTimeRangeChip), findsNWidgets(3));
    },
  );

  testWidgets(
    'invalid endpoint order disables save and cancel resets both cubits',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const AvailabilityPage());
      await harness.load(tester);
      await openWednesday(tester);
      await pickTime(tester, 'Başlangıç', '12');
      await pickTime(tester, 'Bitiş', '09');
      expect(
        find.text('Bitiş saati başlangıçtan sonra olmalı.'),
        findsOneWidget,
      );
      final button = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Kaydet'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(button.onPressed, isNull);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();
      expect(find.byType(AppBottomSheet), findsNothing);
      expect(harness.draft.state.start, isNull);
      await openWednesday(tester);
      expect(find.text('Bitiş saati başlangıçtan sonra olmalı.'), findsNothing);
    },
  );

  testWidgets('chip remove invokes the real remove use case', (tester) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(tester, const AvailabilityPage());
    await harness.load(tester);
    await tester.tap(find.byTooltip('Aralığı kaldır').first);
    await harness.flush(tester);
    expect(harness.repository.updateCalls, 1);
    expect(harness.repository.updatedSubject?.staffId, 'staff');
    expect(harness.repository.current.weekly, [
      AvailabilityPageHarness.fixture.weekly(780, 840),
    ]);
    expect(find.text('09:00–10:00'), findsNothing);
  });

  testWidgets('remove failure shows page feedback without a sheet', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(tester, const AvailabilityPage());
    await harness.load(tester);
    harness.repository.updateError = const AvailabilityException(
      AvailabilityErrorCode.windowNotFound,
    );
    await tester.tap(find.byTooltip('Aralığı kaldır').first);
    await harness.flush(tester);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Aralık artık mevcut değil.'), findsOneWidget);
    expect(find.byType(AppBottomSheet), findsNothing);
  });

  testWidgets(
    'flagged chip announces changed branch hours and remains removable',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const AvailabilityPage());
      await harness.load(
        tester,
        value: AvailabilityPageHarness.fixture.empty.withWeekly([
          AvailabilityPageHarness.fixture.weekly(420, 480),
        ]),
      );
      expect(
        tester.widget<AppTimeRangeChip>(find.byType(AppTimeRangeChip)).variant,
        AppTimeRangeChipVariant.flagged,
      );
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is Semantics &&
              widget.properties.label == '07:00–08:00 · Şube saatleri dışında',
        ),
        findsOneWidget,
      );
      await tester.tap(find.byTooltip('Aralığı kaldır'));
      await harness.flush(tester);
      expect(find.byType(AppTimeRangeChip), findsNothing);
    },
  );

  for (final failsBranch in [false, true]) {
    testWidgets(
      'loading, failure and retry rewatch both sources branch=$failsBranch',
      (tester) async {
        addTearDown(() => harness.dispose(tester));
        await harness.pump(tester, const AvailabilityPage());
        expect(find.byType(LoadingState), findsOneWidget);
        await harness.load(tester);
        await tester.runAsync(() async {
          if (failsBranch) {
            harness.branchEvents.addError(
              const InstitutionException(InstitutionErrorCode.unavailable),
            );
          } else {
            harness.repository.events.addError(
              const AvailabilityException(AvailabilityErrorCode.invalidRecord),
            );
          }
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(find.byType(ErrorState), findsOneWidget);
        if (!failsBranch) {
          expect(find.text('Uygunluk kaydı okunamadı.'), findsOneWidget);
        }
        final beforeBranch = harness.branchWatchCalls;
        final beforeSchedule = harness.repository.watchCalls;
        await tester.runAsync(() async {
          await tester.tap(find.text('Tekrar dene'));
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pump();
        expect(harness.branchWatchCalls, beforeBranch + 1);
        expect(harness.repository.watchCalls, beforeSchedule + 1);
        expect(
          harness.availability.state,
          isA<WatchLoading<StaffAvailability, AvailabilityErrorCode>>(),
        );
        await harness.load(tester);
        expect(find.byType(ErrorState), findsNothing);
      },
    );
  }

  testWidgets(
    'dated editor offers a bounded date picker and only open weekday options',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, const AvailabilityPage());
      await harness.load(tester);
      await tester.ensureVisible(find.text('Tarih için aralık ekle'));
      await tester.tap(find.text('Tarih için aralık ekle'));
      await tester.pumpAndSettle();
      final date = tester.widget<AppDateField>(find.byType(AppDateField));
      expect(date.first, AvailabilityPageHarness.fixture.monday);
      expect(date.last.toString(), '2027-11-02');
      expect(find.text('Belirli tarih · aralık ekle'), findsOneWidget);
      await tester.tap(find.text('Her hafta'));
      await tester.pumpAndSettle();
      final days = tester.widget<AppSelectField<Weekday>>(
        find.byType(AppSelectField<Weekday>),
      );
      expect(days.options.map((option) => option.value), [
        Weekday.monday,
        Weekday.tuesday,
        Weekday.wednesday,
        Weekday.thursday,
        Weekday.friday,
      ]);
    },
  );

  testWidgets('dated window can be added through the picker and removed', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(tester, const AvailabilityPage());
    await harness.load(tester, value: AvailabilityPageHarness.fixture.empty);
    await tester.ensureVisible(find.text('Tarih için aralık ekle'));
    await tester.tap(find.text('Tarih için aralık ekle'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AppDateField),
        matching: find.byType(InkWell),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(DatePickerDialog), findsOneWidget);
    await tester.tap(find.text('3'));
    await tester.tap(find.text('Tamam'));
    await tester.pumpAndSettle();
    await pickTime(tester, 'Başlangıç', '16');
    await pickTime(tester, 'Bitiş', '17');
    await tester.tap(find.text('Kaydet'));
    await harness.flush(tester);
    expect(find.byType(AppBottomSheet), findsNothing);
    expect(
      harness.repository.current.oneOff.single.date,
      AvailabilityPageHarness.fixture.tuesday,
    );
    await tester.ensureVisible(find.byTooltip('Tek seferlik aralığı kaldır'));
    await tester.tap(find.byTooltip('Tek seferlik aralığı kaldır'));
    await harness.flush(tester);
    expect(harness.repository.current.oneOff, isEmpty);
    expect(harness.repository.updateCalls, 2);
  });

  testWidgets('large-text dark mobile keeps the sheet and time fields usable', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(
      tester,
      const AvailabilityPage(),
      dark: true,
      textScaler: const TextScaler.linear(1.5),
    );
    await harness.load(tester);
    await openWednesday(tester);
    expect(find.byType(AppTimeField), findsNWidgets(2));
    await tester.ensureVisible(find.text('Vazgeç'));
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('dismissed in-flight add never reports as a remove failure', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(tester, const AvailabilityPage());
    await harness.load(tester);
    harness.repository.updateGate = Completer<void>();
    harness.repository.updateError = const AvailabilityException(
      AvailabilityErrorCode.unavailable,
    );
    await openWednesday(tester);
    await pickTime(tester, 'Başlangıç', '09');
    await pickTime(tester, 'Bitiş', '12');
    await tester.tap(find.text('Kaydet'));
    await tester.pump();
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    harness.repository.updateGate?.complete();
    await harness.flush(tester);
    expect(find.byType(SnackBar), findsNothing);
    await openWednesday(tester);
    expect(
      find.text('Uygunluk şu anda yüklenemiyor. Lütfen tekrar deneyin.'),
      findsNothing,
    );
  });

  testWidgets('non-staff profile gets the page-specific empty presentation', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await harness.dispose(tester);
      harness = AvailabilityPageHarness();
      await harness.initialize(
        user: const Patient(
          id: 'patient',
          fullName: 'Hasta',
          email: 'hasta@example.com',
        ),
      );
    });
    addTearDown(() => harness.dispose(tester));
    await harness.pump(tester, const AvailabilityPage());
    expect(find.text('Personel bulunamadı'), findsOneWidget);
    expect(find.byType(AvailabilityBody), findsNothing);
  });
}
