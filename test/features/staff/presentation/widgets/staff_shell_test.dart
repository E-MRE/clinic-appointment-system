import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/availability/presentation/pages/availability_page.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../appointments/domain/support/appointment_fixture.dart';
import '../../../availability/presentation/pages/doubles/availability_page_harness.dart';

void main() {
  late AvailabilityPageHarness harness;

  setUp(() async {
    harness = AvailabilityPageHarness();
    await harness.initialize();
  });

  for (final size in [
    AvailabilityPageHarness.mobile,
    AvailabilityPageHarness.tablet,
    AvailabilityPageHarness.desktop,
  ]) {
    testWidgets('doctor at /staff lands inside staff shell at $size', (
      tester,
    ) async {
      addTearDown(() => harness.dispose(tester));
      final guard = AuthRouteGuard(harness.auth);
      final router = createAppRouter(
        initialLocation: AppRoutes.staffHome,
        authGuard: guard,
      );
      addTearDown(() {
        router.dispose();
        guard.dispose();
      });
      await harness.pumpRouter(tester, router, size: size);
      await harness.load(tester);
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.staffAvailability,
      );
      expect(find.byType(StaffShell), findsOneWidget);
      expect(find.byType(AvailabilityPage), findsOneWidget);
      if (size == AvailabilityPageHarness.mobile) {
        expect(find.byType(AppTimeRangeChip), findsNWidgets(2));
      } else {
        expect(find.text('09:00–10:00'), findsOneWidget);
        expect(find.text('13:00–14:00'), findsOneWidget);
      }
      if (size == AvailabilityPageHarness.desktop) {
        expect(find.byType(AppNavigationUserCard), findsOneWidget);
        expect(find.text('Ada Kaya'), findsOneWidget);
        expect(find.text('Doktor · Kardiyoloji'), findsOneWidget);
        await tester.tap(find.byTooltip('Çıkış yap'));
        await harness.flush(tester);
        verify(() => harness.authRepository.signOut()).called(1);
      } else {
        expect(find.byType(AppNavigationUserCard), findsNothing);
      }
      router.go(AppRoutes.adminStaffEdit('ada'));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.staffAvailability,
      );
      expect(find.byType(StaffShell), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    '/staff redirects to availability and lists staff destinations in order',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      final router = createAppRouter(initialLocation: AppRoutes.staffHome);
      addTearDown(router.dispose);
      await harness.pumpRouter(tester, router);
      await harness.load(tester);

      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.staffAvailability,
      );
      final shell = tester.widget<AppNavigationShell>(
        find.byType(AppNavigationShell),
      );
      expect(shell.destinations.map((destination) => destination.label), [
        'Talepler',
        'Uygunluk',
      ]);
    },
  );

  testWidgets(
    'Talepler item shows the pending count, and no badge when there are none',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      final router = createAppRouter(initialLocation: AppRoutes.staffHome);
      addTearDown(router.dispose);
      await harness.pumpRouter(tester, router);
      await harness.load(tester);

      var shell = tester.widget<AppNavigationShell>(
        find.byType(AppNavigationShell),
      );
      final requestsDestination = shell.destinations.firstWhere(
        (destination) => destination.label == 'Talepler',
      );
      expect(requestsDestination.badgeCount, isNull);

      const fixture = AppointmentFixture();
      final pending1 = Appointment.restore(
        id: 'p1',
        patientId: 'patient',
        patientName: 'Patient',
        staffId: 'staff',
        branchId: 'branch',
        departmentId: 'department',
        serviceId: 'service',
        serviceName: 'Examination',
        fee: fixture.fee,
        date: CalendarDate(year: 2026, month: 11, day: 3),
        range: fixture.range,
        status: AppointmentStatus.pending,
        history: [fixture.change(AppointmentStatus.pending)],
      );
      final pending2 = Appointment.restore(
        id: 'p2',
        patientId: 'patient',
        patientName: 'Patient',
        staffId: 'staff',
        branchId: 'branch',
        departmentId: 'department',
        serviceId: 'service',
        serviceName: 'Examination',
        fee: fixture.fee,
        date: CalendarDate(year: 2026, month: 11, day: 4),
        range: fixture.range,
        status: AppointmentStatus.pending,
        history: [fixture.change(AppointmentStatus.pending)],
      );
      harness.appointmentsRepository.events.add(
        DataResult.success(data: [pending1, pending2]),
      );
      await tester.pumpAndSettle();

      shell = tester.widget<AppNavigationShell>(
        find.byType(AppNavigationShell),
      );
      final badgedRequests = shell.destinations.firstWhere(
        (destination) => destination.label == 'Talepler',
      );
      expect(badgedRequests.badgeCount, 2);
    },
  );

  testWidgets('mobile sheet barrier covers the shell navigation', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    final router = createAppRouter(initialLocation: AppRoutes.staffHome);
    addTearDown(router.dispose);
    await harness.pumpRouter(tester, router);
    await harness.load(tester);
    await tester.tap(find.byTooltip('Çarşamba için aralık ekle'));
    await tester.pumpAndSettle();
    final barrier = find.byType(ModalBarrier).last;
    expect(
      tester.getRect(barrier),
      Offset.zero & AvailabilityPageHarness.mobile,
    );
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    expect(harness.availability.isClosed, isFalse);
    expect(harness.save.isClosed, isFalse);
  });

  testWidgets(
    'technician uses availability home and cannot open administrator staff',
    (tester) async {
      await tester.runAsync(() async {
        await harness.dispose(tester);
        harness = AvailabilityPageHarness();
        await harness.initialize(
          user: AvailabilityPageHarness.staffFixtures.technician(id: 'staff'),
        );
      });
      addTearDown(() => harness.dispose(tester));
      final guard = AuthRouteGuard(harness.auth);
      final router = createAppRouter(
        initialLocation: AppRoutes.adminStaff,
        authGuard: guard,
      );
      addTearDown(() {
        router.dispose();
        guard.dispose();
      });
      await harness.pumpRouter(
        tester,
        router,
        size: AvailabilityPageHarness.desktop,
      );
      await harness.load(tester);
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.staffAvailability,
      );
      expect(find.text('Teknisyen'), findsOneWidget);
      expect(find.text('Ece Kaya'), findsOneWidget);
    },
  );
}
