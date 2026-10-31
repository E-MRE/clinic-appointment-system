import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/widgets/form_dialog/app_form_dialog.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_shell.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_destination.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_shell.dart';
import 'package:clinic_appointment_system/features/availability/presentation/widgets/availability_body.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_availability_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/widgets/staff_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../availability/presentation/pages/doubles/availability_page_harness.dart';
import 'doubles/staff_page_harness.dart';

void main() {
  late StaffPageHarness staff;
  late AvailabilityPageHarness availability;

  setUp(() async {
    staff = StaffPageHarness();
    availability = AvailabilityPageHarness();
    await staff.initialize();
    staff.registerAdminScope();
    availability.registerCubits();
  });

  Future<void> dispose(WidgetTester tester) async {
    await staff.dispose(tester);
    await availability.disposeRepositories();
  }

  testWidgets(
    'direct route resolves staff inside selected admin destination and back',
    (tester) async {
      addTearDown(() => dispose(tester));
      final router = createAppRouter(
        initialLocation: AppRoutes.adminStaffAvailability('ayse'),
      );
      addTearDown(router.dispose);
      await staff.pumpRouter(tester, router, size: StaffPageHarness.desktop);
      expect(find.byType(LoadingState), findsWidgets);
      await staff.emitBranches(tester);
      await staff.emitStaff(
        tester,
        DataResult.success(
          data: [
            StaffPageHarness.fixtures.doctor(
              id: 'ayse',
              fullName: 'Dr. Ayşe Yılmaz',
            ),
          ],
        ),
      );
      await availability.load(tester);
      expect(find.byType(AdminShell), findsOneWidget);
      expect(
        tester
            .widget<AppNavigationShell>(find.byType(AppNavigationShell))
            .selectedIndex,
        AdminDestination.staff.index,
      );
      expect(find.byType(StaffAvailabilityPage), findsOneWidget);
      expect(
        find.text('Dr. Ayşe Yılmaz · Doktor · Kardiyoloji'),
        findsOneWidget,
      );
      expect(find.byType(AvailabilityBody), findsOneWidget);
      expect(find.text('09:00–10:00'), findsWidgets);
      await tester.tap(find.byTooltip('Geri'));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.adminStaff,
      );
    },
  );

  testWidgets('unknown staff displays the shared not-found view', (
    tester,
  ) async {
    addTearDown(() => dispose(tester));
    final router = createAppRouter(
      initialLocation: AppRoutes.adminStaffAvailability('unknown'),
    );
    addTearDown(router.dispose);
    await staff.pumpRouter(tester, router);
    await staff.load(tester);
    expect(find.text('Personel bulunamadı'), findsOneWidget);
    expect(find.byType(AvailabilityBody), findsNothing);
  });

  for (final size in [
    const Size(1200, 960),
    StaffPageHarness.tablet,
    StaffPageHarness.mobile,
  ]) {
    testWidgets('availability actions navigate independently at $size', (
      tester,
    ) async {
      addTearDown(() => dispose(tester));
      final router = createAppRouter(initialLocation: AppRoutes.adminStaff);
      addTearDown(router.dispose);
      await staff.pumpRouter(tester, router, size: size);
      await staff.load(tester);
      final buttons = find.byTooltip('Uygunluk');
      expect(buttons, findsNWidgets(3));
      await tester.ensureVisible(buttons.first);
      await tester.tap(buttons.first);
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.adminStaffAvailability('ada'),
      );
      expect(find.byType(AppFormDialog), findsNothing);
      if (size == StaffPageHarness.mobile) {
        router.go(AppRoutes.adminStaff);
        await tester.pumpAndSettle();
        await tester.tap(find.text('Ada Kaya'));
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.path,
          AppRoutes.adminStaffEdit('ada'),
        );
        expect(
          tester.widget<StaffForm>(find.byType(StaffForm)).staff?.id,
          'ada',
        );
      }
    });
  }
}
