import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_appointment_row_presentation.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'doubles/admin_appointments_page_harness.dart';

void main() {
  List<Appointment> overviewRows() {
    const fixtures = AdminAppointmentsPageHarness.fixtures;
    return [
      fixtures.appointment(
        id: 'pending-today',
        status: AppointmentStatus.pending,
        startMinutes: 600,
        createdAt: DateTime(2026, 11, 14, 6),
      ),
      fixtures.appointment(
        id: 'pending-tomorrow',
        status: AppointmentStatus.pending,
        date: DateTime(2026, 11, 15),
        startMinutes: 630,
        branchId: 'branch-b',
        departmentId: 'department-b',
        staffId: 'staff-b',
        createdAt: DateTime(2026, 11, 14, 7),
      ),
      fixtures.appointment(
        id: 'completed-today',
        status: AppointmentStatus.completed,
        startMinutes: 660,
      ),
      fixtures.appointment(
        id: 'no-show-today',
        status: AppointmentStatus.noShow,
        startMinutes: 690,
        branchId: 'branch-b',
        departmentId: 'department-b',
        staffId: 'staff-b',
      ),
    ];
  }

  testWidgets('renders KPI values, breakdown rows and pending actions', (
    tester,
  ) async {
    final harness = AdminAppointmentsPageHarness();
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    await harness.pumpHomePage(tester);
    await harness.loadData(tester, overviewRows());

    final todayCard = find.ancestor(
      of: find.text('Bugünkü randevu'),
      matching: find.byType(AppSurface),
    );
    final pendingCard = find.ancestor(
      of: find.text('Onay bekleyen'),
      matching: find.byType(AppSurface),
    );
    final completedCard = find.ancestor(
      of: find.text('Bugün tamamlanan'),
      matching: find.byType(AppSurface),
    );
    final noShowCard = find.ancestor(
      of: find.text('Bugün gelmeyen'),
      matching: find.byType(AppSurface),
    );
    expect(
      find.descendant(of: todayCard, matching: find.text('3')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: pendingCard, matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: completedCard, matching: find.text('1')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: noShowCard, matching: find.text('1')),
      findsOneWidget,
    );
    expect(find.text('2 şube · 2 personel'), findsOneWidget);
    expect(find.text('En eskisi 2 saat önce'), findsOneWidget);

    expect(find.text('Cardiology'), findsOneWidget);
    expect(find.text('Neurology'), findsOneWidget);
    expect(find.text('Zeynep Aydın'), findsWidgets);
    expect(find.text('Burak Kaya'), findsWidgets);
    expect(find.text('Patient pending-today'), findsOneWidget);
    expect(find.text('Patient pending-tomorrow'), findsOneWidget);
    expect(find.text('2 saat önce'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Onayla'), findsNWidgets(2));
    expect(find.widgetWithText(OutlinedButton, 'Reddet'), findsNWidgets(2));
    expect(harness.adminDashboardCubit?.state, isA<AdminDashboardLoaded>());
  });

  testWidgets('branch selection filters the dashboard summary', (tester) async {
    final harness = AdminAppointmentsPageHarness();
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    await harness.pumpHomePage(tester);
    await harness.loadData(tester, overviewRows());

    final branchSelect = find.byType(DropdownButtonFormField<String>);
    expect(branchSelect, findsOneWidget);
    await tester.tap(branchSelect);
    await tester.pumpAndSettle();
    await tester.tap(find.text('South Branch').last);
    await tester.pumpAndSettle();

    final dashboardState = harness.adminDashboardCubit?.state;
    expect(dashboardState, isA<AdminDashboardLoaded>());
    if (dashboardState is AdminDashboardLoaded) {
      expect(dashboardState.summary.selectedBranchId, 'branch-b');
      expect(dashboardState.summary.todayAppointmentCount, 1);
      expect(dashboardState.summary.noShowCount, 1);
    }
  });

  testWidgets('empty data shows messages for charts and pending requests', (
    tester,
  ) async {
    final harness = AdminAppointmentsPageHarness();
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    await harness.pumpHomePage(tester);
    await harness.loadData(tester, const []);

    expect(find.text('Bugün için durum verisi yok.'), findsOneWidget);
    expect(find.text('Bugün için bölüm verisi yok.'), findsOneWidget);
    expect(find.text('Bugün için personel verisi yok.'), findsOneWidget);
    expect(find.text('Onay bekleyen talep yok.'), findsOneWidget);
  });

  testWidgets('failure state can retry the dashboard observation', (
    tester,
  ) async {
    final harness = AdminAppointmentsPageHarness();
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    await harness.pumpHomePage(tester);
    await harness.loadCatalog(tester);
    await harness.failAppointments(tester);

    expect(find.text('Randevu özeti yüklenemedi'), findsOneWidget);
    final retry = find.widgetWithText(FilledButton, 'Tekrar dene');
    expect(retry, findsOneWidget);
    await tester.tap(retry);
    await tester.pump();

    expect(find.byType(LoadingState), findsOneWidget);
    expect(harness.appointments.watchedAdminQueries.length, 2);
  });

  testWidgets('all appointments button navigates to the list', (tester) async {
    final harness = AdminAppointmentsPageHarness();
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    final router = await harness.pumpRoutedHomePage(tester);
    await harness.loadData(tester, overviewRows());

    final allAppointments = find.widgetWithText(FilledButton, 'Tüm randevular');
    await tester.ensureVisible(allAppointments);
    await tester.tap(allAppointments);
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.adminAppointments,
    );

    await harness.emitRows(tester, overviewRows());
    final appointmentsState = harness.adminAppointmentsCubit?.state;
    expect(appointmentsState, isA<AdminAppointmentsLoaded>());
    if (appointmentsState is AdminAppointmentsLoaded) {
      expect(appointmentsState.filter.statuses, isEmpty);
    }
  });

  testWidgets('see all opens the appointments list with pending selected', (
    tester,
  ) async {
    final harness = AdminAppointmentsPageHarness();
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    final router = await harness.pumpRoutedHomePage(tester);
    await harness.loadData(tester, overviewRows());

    final seeAll = find.widgetWithText(TextButton, 'Tümünü gör');
    await tester.ensureVisible(seeAll);
    await tester.tap(seeAll);
    await tester.pumpAndSettle();
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.adminAppointments,
    );
    expect(
      router.routeInformationProvider.value.uri.queryParameters[AppRoutes
          .adminAppointmentStatusParameter],
      AppRoutes.adminPendingStatusValue,
    );

    await harness.emitRows(tester, overviewRows());
    final appointmentsState = harness.adminAppointmentsCubit?.state;
    expect(appointmentsState, isA<AdminAppointmentsLoaded>());
    if (appointmentsState is AdminAppointmentsLoaded) {
      expect(appointmentsState.filter.statuses, const {
        AdminStatusFilter.pending,
      });
      expect(
        appointmentsState.filteredAppointments.every(
          (appointment) => appointment.status == AppointmentStatus.pending,
        ),
        isTrue,
      );
    }
  });

  testWidgets('narrow overview scrolls the table without overflowing', (
    tester,
  ) async {
    final harness = AdminAppointmentsPageHarness();
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    await harness.pumpHomePage(tester, size: const Size(390, 844));
    await harness.loadData(tester, overviewRows());

    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: find.byType(AppDataTable<AdminAppointmentRowPresentation>),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is SingleChildScrollView &&
              widget.scrollDirection == Axis.horizontal,
        ),
      ),
      findsOneWidget,
    );
  });
}
