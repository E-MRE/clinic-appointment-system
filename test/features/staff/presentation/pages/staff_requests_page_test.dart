import 'dart:async';

import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_reason_dialog.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_shell.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'doubles/staff_requests_page_harness.dart';

void main() {
  late StaffRequestsPageHarness harness;

  setUp(() async {
    harness = StaffRequestsPageHarness();
    await harness.initialize();
  });

  Appointment makeRequest({
    required String id,
    required String patientName,
    required CalendarDate date,
    required TimeRange range,
    required DateTime requestedAt,
    String serviceName = 'Kardiyoloji Muayenesi',
    Money? fee,
  }) {
    return Appointment.restore(
      id: id,
      patientId: 'patient-$id',
      patientName: patientName,
      staffId: harness.staff.id,
      branchId: 'branch',
      departmentId: 'department',
      serviceId: 'service',
      serviceName: serviceName,
      fee: fee ?? Money.minorUnits(120000),
      date: date,
      range: range,
      status: AppointmentStatus.pending,
      history: [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: 'patient-$id',
          byRole: UserRole.patient,
          at: requestedAt,
        ),
      ],
    );
  }

  void configurePassingWorkspace({
    StaffAvailability? availability,
    WorkingHours? workingHours,
  }) {
    when(() => harness.branchRepo.watchBranch(any())).thenAnswer(
      (_) => Stream.value(
        DataResult.success(
          data: Branch(
            id: 'branch',
            clinicId: 'clinic',
            name: 'Merkez Şube',
            address: 'Adres',
            workingHours:
                workingHours ??
                WorkingHours({
                  Weekday.tuesday: [
                    TimeRange(
                      start: ClockTime(hour: 8, minute: 30),
                      end: ClockTime(hour: 18, minute: 0),
                    ),
                  ],
                }),
          ),
        ),
      ),
    );
    harness.servicesRepo.servicesStream = Stream.value(
      DataResult<List<MedicalService>>.success(
        data: [
          Examination(
            id: 'service',
            branchId: 'branch',
            departmentId: 'department',
            name: 'Kardiyoloji Muayenesi',
            duration: ServiceDuration(20),
            fee: Money.minorUnits(120000),
          ),
        ],
      ),
    ).asBroadcastStream();
    harness.availabilityRepo.stream = Stream.value(
      DataResult.success(
        data:
            availability ??
            StaffAvailability(
              staffId: harness.staff.id,
              branchId: 'branch',
              weekly: [
                WeeklyWindow(
                  weekday: Weekday.tuesday,
                  range: TimeRange(
                    start: ClockTime(hour: 9, minute: 0),
                    end: ClockTime(hour: 12, minute: 0),
                  ),
                ),
              ],
            ),
      ),
    ).asBroadcastStream();
  }

  testWidgets(
    'desktop shows header, cards in date order, reorders on sort, and selects cards',
    (tester) async {
      addTearDown(() => harness.dispose(tester));

      // requestEarlierDate: Starts 27 Oct, requested 20 Oct 08:00 (1 hour ago from clock 09:00)
      final requestEarlierDate = makeRequest(
        id: 'req-earlier-date',
        patientName: 'Ali Yılmaz',
        date: CalendarDate(year: 2026, month: 10, day: 27),
        range: TimeRange(
          start: ClockTime(hour: 9, minute: 20),
          end: ClockTime(hour: 9, minute: 40),
        ),
        requestedAt: DateTime(2026, 10, 20, 8),
      );

      // requestEarlierCreated: Starts 28 Oct, requested 20 Oct 07:00 (2 hours ago from clock 09:00)
      final requestEarlierCreated = makeRequest(
        id: 'req-earlier-created',
        patientName: 'Ayşe Demir',
        date: CalendarDate(year: 2026, month: 10, day: 28),
        range: TimeRange(
          start: ClockTime(hour: 10, minute: 0),
          end: ClockTime(hour: 10, minute: 30),
        ),
        requestedAt: DateTime(2026, 10, 20, 7),
      );

      await harness.pump(tester, size: StaffRequestsPageHarness.desktop);
      await harness.emitAndPump(tester, [
        requestEarlierCreated,
        requestEarlierDate,
      ]);

      // Header title and subtitle with oldest request age (2 hours ago)
      expect(find.text('Onay bekleyen talepler'), findsOneWidget);
      expect(
        find.text('2 talep · en eskisi 2 saat önce oluşturuldu'),
        findsOneWidget,
      );

      // Sort toggle choices
      expect(find.text('Tarihe göre'), findsOneWidget);
      expect(find.text('Talep sırasına göre'), findsOneWidget);

      // By default, sorted by date: Ali Yılmaz (27 Oct) appears before Ayşe Demir (28 Oct)
      final firstCardFinder = find.widgetWithText(InkWell, 'Ali Yılmaz');
      final secondCardFinder = find.widgetWithText(InkWell, 'Ayşe Demir');
      expect(firstCardFinder, findsOneWidget);
      expect(secondCardFinder, findsOneWidget);
      expect(
        tester.getTopLeft(firstCardFinder).dy,
        lessThan(tester.getTopLeft(secondCardFinder).dy),
      );

      // Card row contents
      expect(
        find.descendant(of: firstCardFinder, matching: find.text('AY')),
        findsOneWidget,
      );
      expect(
        find.text('Sal 27 Eki · 09:20 · Kardiyoloji Muayenesi'),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: firstCardFinder,
          matching: find.text('1 saat önce talep etti'),
        ),
        findsOneWidget,
      );

      // Detail panel placeholder shows selected patient name (first card Ali Yılmaz selected by default)
      // Detail panel is in the right column
      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Ali Yılmaz'),
        ),
        findsNothing,
      );
      expect(
        tester.widgetList(find.text('Ali Yılmaz')).length,
        2, // once in card list, once in detail panel
      );

      // Tap second card (Ayşe Demir) to select it
      await tester.tap(secondCardFinder);
      await tester.pumpAndSettle();

      // Detail panel now shows Ayşe Demir
      expect(
        tester.widgetList(find.text('Ayşe Demir')).length,
        2, // once in card list, once in detail panel
      );

      // Switch sort to "Talep sırasına göre"
      await tester.tap(find.text('Talep sırasına göre'));
      await tester.pumpAndSettle();

      // Ayşe Demir (requested at 07:00) now appears before Ali Yılmaz (requested at 08:00)
      expect(
        tester.getTopLeft(find.widgetWithText(InkWell, 'Ayşe Demir')).dy,
        lessThan(
          tester.getTopLeft(find.widgetWithText(InkWell, 'Ali Yılmaz')).dy,
        ),
      );

      // Approve flow from desktop detail placeholder
      expect(find.text('Onayla'), findsOneWidget);
      await tester.tap(find.text('Onayla'));
      await tester.pumpAndSettle();

      expect(harness.repository.changedIds, [requestEarlierCreated.id]);
      expect(
        harness.repository.stored[requestEarlierCreated.id]?.status,
        AppointmentStatus.approved,
      );
    },
  );

  testWidgets(
    'narrow layout shows cards and opens detail panel in a dialog on tap',
    (tester) async {
      addTearDown(() => harness.dispose(tester));

      final request = makeRequest(
        id: 'narrow-req',
        patientName: 'Zeynep Kaya',
        date: CalendarDate(year: 2026, month: 10, day: 27),
        range: TimeRange(
          start: ClockTime(hour: 9, minute: 20),
          end: ClockTime(hour: 9, minute: 40),
        ),
        requestedAt: DateTime(2026, 10, 20, 8),
      );

      await harness.pump(tester, size: StaffRequestsPageHarness.mobile);
      await harness.emitAndPump(tester, [request]);

      // Initially no dialog and no side-by-side detail panel
      expect(find.byType(Dialog), findsNothing);
      expect(find.text('Zeynep Kaya'), findsOneWidget); // Only in the card

      // Tap card to open dialog
      await tester.tap(find.widgetWithText(InkWell, 'Zeynep Kaya'));
      await tester.pumpAndSettle();

      // Dialog is open with the detail panel
      expect(find.byType(Dialog), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Dialog),
          matching: find.text('Zeynep Kaya'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(of: find.byType(Dialog), matching: find.text('Onayla')),
        findsOneWidget,
      );

      // Approve through dialog
      await tester.tap(
        find.descendant(of: find.byType(Dialog), matching: find.text('Onayla')),
      );
      await tester.pumpAndSettle();

      expect(harness.repository.changedIds, [request.id]);
      expect(
        harness.repository.stored[request.id]?.status,
        AppointmentStatus.approved,
      );
    },
  );

  testWidgets('shows approval progress and a localized failure', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    final pending = Completer<AppointmentResult>();
    harness.repository.pendingChange = pending;

    final request = makeRequest(
      id: 'req-failure',
      patientName: 'Ali Yılmaz',
      date: CalendarDate(year: 2026, month: 10, day: 27),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 20),
        end: ClockTime(hour: 9, minute: 40),
      ),
      requestedAt: DateTime(2026, 10, 20, 8),
    );

    await harness.pump(tester, size: StaffRequestsPageHarness.desktop);
    await harness.emitAndPump(tester, [request]);

    await tester.tap(find.text('Onayla'));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    pending.complete(
      const AppointmentResult.error(AppointmentErrorCode.notPermitted),
    );
    await tester.pumpAndSettle();

    expect(find.text('Bu işlem için yetkiniz yok.'), findsOneWidget);
  });

  testWidgets('shows empty state when no request awaits approval', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(tester, size: StaffRequestsPageHarness.mobile);
    await harness.emitAndPump(tester, []);

    expect(find.text('Onay bekleyen talepler'), findsOneWidget);
    expect(find.text('0 talep'), findsOneWidget);
    expect(find.text('Onay bekleyen talep yok.'), findsOneWidget);
    expect(find.text('Onayla'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final size in const [
    StaffRequestsPageHarness.mobile,
    StaffRequestsPageHarness.tablet,
    StaffRequestsPageHarness.desktop,
  ]) {
    testWidgets('keeps a long patient name without overflow at $size', (
      tester,
    ) async {
      addTearDown(() => harness.dispose(tester));
      final request = makeRequest(
        id: 'overflow-test',
        patientName: 'Mehmet Ali Karaosmanoğlu',
        date: CalendarDate(year: 2026, month: 10, day: 27),
        range: TimeRange(
          start: ClockTime(hour: 9, minute: 20),
          end: ClockTime(hour: 9, minute: 40),
        ),
        requestedAt: DateTime(2026, 10, 20, 8),
      );

      await harness.pump(tester, size: size);
      await harness.emitAndPump(tester, [request]);

      expect(find.text('Mehmet Ali Karaosmanoğlu'), findsWidgets);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('opens the requests destination inside the staff shell', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    final guard = AuthRouteGuard(harness.auth);
    final router = createAppRouter(
      initialLocation: AppRoutes.staffRequests,
      authGuard: guard,
    );
    addTearDown(() {
      router.dispose();
      guard.dispose();
    });

    final request = makeRequest(
      id: 'shell-test',
      patientName: 'Ali Yılmaz',
      date: CalendarDate(year: 2026, month: 10, day: 27),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 20),
        end: ClockTime(hour: 9, minute: 40),
      ),
      requestedAt: DateTime(2026, 10, 20, 8),
    );

    await harness.pumpRouter(
      tester,
      router,
      size: StaffRequestsPageHarness.mobile,
    );
    await harness.emitAndPump(tester, [request]);

    expect(find.byType(StaffShell), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.staffRequests,
    );
    expect(find.text('Onay bekleyen talepler'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'desktop panel shows patient name, definition grid, four passed rules with fixture, and history badge when patient has completed visit',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      configurePassingWorkspace();

      final request = makeRequest(
        id: 'req-full',
        patientName: 'Ali Yılmaz',
        date: CalendarDate(year: 2026, month: 10, day: 27),
        range: TimeRange(
          start: ClockTime(hour: 9, minute: 20),
          end: ClockTime(hour: 9, minute: 40),
        ),
        requestedAt: DateTime(2026, 10, 20, 8),
      );

      final completed = Appointment.restore(
        id: 'past-completed',
        patientId: request.patientId,
        patientName: request.patientName,
        staffId: harness.staff.id,
        branchId: 'branch',
        departmentId: 'department',
        serviceId: 'service',
        serviceName: 'Kardiyoloji Muayenesi',
        fee: Money.minorUnits(120000),
        date: CalendarDate(year: 2026, month: 9, day: 14),
        range: TimeRange(
          start: ClockTime(hour: 10, minute: 0),
          end: ClockTime(hour: 10, minute: 20),
        ),
        status: AppointmentStatus.completed,
        history: [
          AppointmentStatusChange(
            status: AppointmentStatus.completed,
            byUserId: harness.staff.id,
            byRole: UserRole.doctor,
            at: DateTime(2026, 9, 14, 10, 20),
          ),
        ],
      );

      await harness.pump(tester, size: StaffRequestsPageHarness.desktop);
      await harness.emitAndPump(tester, [request, completed]);

      // Patient name in detail panel
      expect(find.text('Ali Yılmaz'), findsWidgets);

      // Definition grid values
      expect(find.text('Sal 27 Eki · 09:20–09:40'), findsOneWidget);
      expect(find.text('20 dk · ₺1.200'), findsOneWidget);
      expect(find.text('Merkez Şube · Cardiology'), findsOneWidget);

      // Four live rule checks all passed
      expect(find.text('Kural kontrolü'), findsOneWidget);
      expect(
        find.text('Uygunluk aralığınızda (Salı 09:00–12:00)'),
        findsOneWidget,
      );
      expect(
        find.text('Şube çalışma saatleri içinde (08:30–18:00)'),
        findsOneWidget,
      );
      expect(
        find.text('Bu saatte onaylı başka randevunuz yok'),
        findsOneWidget,
      );
      expect(find.text('Bu hizmeti veriyorsunuz'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle_outline), findsNWidgets(4));

      // Patient history section
      expect(find.text('Bu hastayla geçmiş'), findsOneWidget);
      expect(find.text('1 tamamlandı'), findsOneWidget);
      expect(find.text('Son ziyaret: 14 Eylül'), findsOneWidget);
    },
  );

  testWidgets('history section is hidden when patient has no completed visit', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    configurePassingWorkspace();

    final request = makeRequest(
      id: 'req-nohistory',
      patientName: 'Ali Yılmaz',
      date: CalendarDate(year: 2026, month: 10, day: 27),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 20),
        end: ClockTime(hour: 9, minute: 40),
      ),
      requestedAt: DateTime(2026, 10, 20, 8),
    );

    await harness.pump(tester, size: StaffRequestsPageHarness.desktop);
    await harness.emitAndPump(tester, [request]);

    expect(find.text('Bu hastayla geçmiş'), findsNothing);
    expect(find.text('1 tamamlandı'), findsNothing);
  });

  testWidgets('failed rule shows the failure text', (tester) async {
    addTearDown(() => harness.dispose(tester));
    configurePassingWorkspace(
      availability: StaffAvailability(
        staffId: harness.staff.id,
        branchId: 'branch',
        weekly: [
          WeeklyWindow(
            weekday: Weekday.tuesday,
            range: TimeRange(
              start: ClockTime(hour: 14, minute: 0),
              end: ClockTime(hour: 17, minute: 0),
            ),
          ),
        ],
      ),
    );

    final request = makeRequest(
      id: 'req-fail',
      patientName: 'Ali Yılmaz',
      date: CalendarDate(year: 2026, month: 10, day: 27),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 20),
        end: ClockTime(hour: 9, minute: 40),
      ),
      requestedAt: DateTime(2026, 10, 20, 8),
    );

    await harness.pump(tester, size: StaffRequestsPageHarness.desktop);
    await harness.emitAndPump(tester, [request]);

    expect(find.text('Uygunluk aralığınızın dışında'), findsOneWidget);
    expect(find.byIcon(Icons.cancel_outlined), findsOneWidget);
  });

  testWidgets('missing service hides the rule section without error', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    final request = makeRequest(
      id: 'req-nosrv',
      patientName: 'Ali Yılmaz',
      date: CalendarDate(year: 2026, month: 10, day: 27),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 20),
        end: ClockTime(hour: 9, minute: 40),
      ),
      requestedAt: DateTime(2026, 10, 20, 8),
    );

    await harness.pump(tester, size: StaffRequestsPageHarness.desktop);
    await harness.emitAndPump(tester, [request]);

    expect(find.text('Kural kontrolü'), findsNothing);
    expect(find.text('Ali Yılmaz'), findsWidgets);
    expect(find.text('Sal 27 Eki · 09:20–09:40'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'reject flow: Reddet... opens dialog, Vazgeç cancels, confirming with reason calls reject',
    (tester) async {
      addTearDown(() => harness.dispose(tester));

      final request = makeRequest(
        id: 'req-reject',
        patientName: 'Ali Yılmaz',
        date: CalendarDate(year: 2026, month: 10, day: 27),
        range: TimeRange(
          start: ClockTime(hour: 9, minute: 20),
          end: ClockTime(hour: 9, minute: 40),
        ),
        requestedAt: DateTime(2026, 10, 20, 8),
      );

      await harness.pump(tester, size: StaffRequestsPageHarness.desktop);
      await harness.emitAndPump(tester, [request]);

      // Tap "Reddet…"
      await tester.tap(find.text('Reddet…'));
      await tester.pumpAndSettle();

      // Reason dialog is open with title and subtitle
      expect(find.byType(AppointmentReasonDialog), findsOneWidget);
      expect(find.text('Talebi reddet'), findsOneWidget);
      expect(
        find.text('Ali Yılmaz · Sal 27 Eki · 09:20 · Kardiyoloji Muayenesi'),
        findsOneWidget,
      );

      // Tap "Vazgeç": dialog dismissed, nothing rejected
      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();

      expect(find.byType(AppointmentReasonDialog), findsNothing);
      expect(harness.repository.changedIds, isEmpty);

      // Tap "Reddet…" again, type reason and confirm
      await tester.tap(find.text('Reddet…'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Doktor izinde');
      await tester.tap(
        find.descendant(
          of: find.byType(AppointmentReasonDialog),
          matching: find.text('Reddet'),
        ),
      );
      await tester.pumpAndSettle();

      expect(harness.repository.changedIds, [request.id]);
      expect(
        harness.repository.stored[request.id]?.status,
        AppointmentStatus.rejected,
      );
      expect(
        harness.repository.stored[request.id]?.statusReason,
        'Doktor izinde',
      );
      expect(find.text('Talep reddedildi.'), findsOneWidget);
    },
  );

  testWidgets('narrow dialog shows the same panel and closes on rejection', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    configurePassingWorkspace();

    final request = makeRequest(
      id: 'narrow-reject',
      patientName: 'Ali Yılmaz',
      date: CalendarDate(year: 2026, month: 10, day: 27),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 20),
        end: ClockTime(hour: 9, minute: 40),
      ),
      requestedAt: DateTime(2026, 10, 20, 8),
    );

    await harness.pump(tester, size: StaffRequestsPageHarness.mobile);
    await harness.emitAndPump(tester, [request]);

    // Tap card to open dialog
    await tester.tap(find.widgetWithText(InkWell, 'Ali Yılmaz'));
    await tester.pumpAndSettle();

    expect(find.byType(Dialog), findsOneWidget);
    expect(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.text('Kural kontrolü'),
      ),
      findsOneWidget,
    );

    // Reject from dialog
    await tester.tap(
      find.descendant(of: find.byType(Dialog), matching: find.text('Reddet…')),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppointmentReasonDialog), findsOneWidget);
    await tester.tap(
      find.descendant(
        of: find.byType(AppointmentReasonDialog),
        matching: find.text('Reddet'),
      ),
    );
    await tester.pumpAndSettle();

    // Both reason dialog and detail dialog are closed!
    expect(find.byType(Dialog), findsNothing);
    expect(harness.repository.changedIds, [request.id]);
    expect(
      harness.repository.stored[request.id]?.status,
      AppointmentStatus.rejected,
    );
    expect(find.text('Talep reddedildi.'), findsOneWidget);
  });
}
