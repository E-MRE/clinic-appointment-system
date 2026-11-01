import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/availability/presentation/pages/availability_page.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
