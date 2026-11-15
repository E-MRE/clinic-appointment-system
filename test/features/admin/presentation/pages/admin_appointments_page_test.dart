import 'package:clinic_appointment_system/core/widgets/choice/app_filter_chips.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'doubles/admin_appointments_page_harness.dart';

void main() {
  testWidgets('waits until catalog and appointments are both loaded', (
    tester,
  ) async {
    final harness = await _pumpPage(tester);

    expect(find.byType(LoadingState), findsOneWidget);
    await harness.loadCatalog(tester);
    expect(find.byType(LoadingState), findsOneWidget);

    await harness.emitRows(tester, harness.appointmentRows(count: 1));

    expect(find.byType(LoadingState), findsNothing);
    expect(_table, findsOneWidget);
    expect(find.text('Patient appointment-0'), findsOneWidget);
  });

  testWidgets('status and patient filters update rows and matching counts', (
    tester,
  ) async {
    await _pumpLoadedPage(tester, rows: harnessRows(count: 4, pendingCount: 2));

    expect(find.text('4 randevu'), findsOneWidget);
    expect(find.text('· 2 beklemede'), findsOneWidget);
    expect(find.text('· 2 onaylandı'), findsOneWidget);

    await tester.tap(_statusChip('Beklemede'));
    await tester.pumpAndSettle();
    expect(find.text('2 randevu'), findsOneWidget);
    expect(find.text('· 2 beklemede'), findsOneWidget);
    expect(
      find.descendant(of: _table, matching: find.text('Patient appointment-0')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: _table, matching: find.text('Patient appointment-2')),
      findsNothing,
    );

    await tester.enterText(find.byType(TextFormField), 'appointment-0');
    await tester.pumpAndSettle();
    expect(find.text('1 randevu'), findsOneWidget);
    expect(find.text('· 1 beklemede'), findsOneWidget);
    expect(
      find.descendant(of: _table, matching: find.text('Patient appointment-0')),
      findsOneWidget,
    );
  });

  testWidgets('branch selection narrows department choices and visible rows', (
    tester,
  ) async {
    await _pumpLoadedPage(tester, rows: harnessRows(count: 4, pendingCount: 1));

    await tester.tap(_selectField(0));
    await tester.pumpAndSettle();
    await tester.tap(find.text('North Branch'));
    await tester.pumpAndSettle();

    expect(find.text('2 randevu'), findsOneWidget);
    expect(
      find.descendant(of: _table, matching: find.text('Patient appointment-1')),
      findsNothing,
    );
    await tester.tap(_selectField(1));
    await tester.pumpAndSettle();
    expect(find.text('Cardiology'), findsOneWidget);
    expect(find.text('Neurology'), findsNothing);
  });

  testWidgets('pagination changes rows and disables controls at each end', (
    tester,
  ) async {
    final harness = await _pumpLoadedPage(
      tester,
      rows: harnessRows(count: 17, pendingCount: 4),
    );

    expect(find.text('1–10 / 17'), findsOneWidget);
    expect(find.text('17 randevu'), findsOneWidget);
    expect(find.text('· 4 beklemede'), findsOneWidget);
    expect(
      tester.widget<IconButton>(_paginationButton('Önceki sayfa')).onPressed,
      isNull,
    );

    final next = find.byTooltip('Sonraki sayfa');
    await tester.ensureVisible(next);
    await tester.tap(next);
    await tester.pumpAndSettle();
    expect(find.text('11–17 / 17'), findsOneWidget);
    expect(
      find.descendant(
        of: _table,
        matching: find.text('Patient appointment-10'),
      ),
      findsOneWidget,
    );
    expect(
      tester.widget<IconButton>(_paginationButton('Sonraki sayfa')).onPressed,
      isNull,
    );

    await tester.tap(_paginationButton('Önceki sayfa'));
    await tester.pumpAndSettle();
    expect(find.text('1–10 / 17'), findsOneWidget);
    final pageState = harness.adminAppointmentsCubit?.state;
    expect(pageState, isA<AdminAppointmentsLoaded>());
    if (pageState is AdminAppointmentsLoaded) {
      expect(pageState.currentPage, 1);
    }
  });

  testWidgets('clear filters resets status and patient query', (tester) async {
    await _pumpLoadedPage(tester, rows: harnessRows(count: 4, pendingCount: 2));

    final clearButton = find.widgetWithText(TextButton, 'Filtreleri temizle');
    expect(tester.widget<TextButton>(clearButton).onPressed, isNull);

    await tester.tap(_statusChip('Beklemede'));
    await tester.enterText(find.byType(TextFormField), 'appointment-0');
    await tester.pumpAndSettle();
    expect(tester.widget<TextButton>(clearButton).onPressed, isNotNull);

    await tester.tap(clearButton);
    await tester.pumpAndSettle();

    expect(find.text('4 randevu'), findsOneWidget);
    expect(find.text('· 2 beklemede'), findsOneWidget);
    expect(find.text('appointment-0'), findsNothing);
    expect(find.text('2–1 / 4'), findsNothing);
    expect(tester.widget<TextButton>(clearButton).onPressed, isNull);
  });

  testWidgets(
    'empty matches use the shared empty state inside the table card',
    (tester) async {
      await _pumpLoadedPage(tester, rows: const []);

      expect(find.text('Randevu bulunamadı'), findsOneWidget);
      expect(find.text('0–0 / 0'), findsOneWidget);
      expect(_table, findsNothing);
    },
  );

  testWidgets('narrow layout keeps the table horizontally scrollable', (
    tester,
  ) async {
    await _pumpLoadedPage(
      tester,
      size: const Size(390, 844),
      rows: harnessRows(count: 2),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.descendant(
        of: _table,
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is SingleChildScrollView &&
              widget.scrollDirection == Axis.horizontal,
        ),
      ),
      findsOneWidget,
    );
  });

  testWidgets('pending row approval uses the signed-in admin actor', (
    tester,
  ) async {
    final harness = await _pumpLoadedPage(tester, rows: harnessRows(count: 1));
    final approve = find.widgetWithText(FilledButton, 'Onayla');
    await tester.ensureVisible(approve);
    await tester.tap(approve);
    await tester.pumpAndSettle();

    final changed = harness.appointments.stored['appointment-0'];
    expect(changed?.status, AppointmentStatus.approved);
    expect(changed?.history.last.byUserId, 'admin-1');
    expect(changed?.history.last.byRole, UserRole.admin);
    expect(find.text('Randevu onaylandı.'), findsOneWidget);
  });

  testWidgets('pending row rejection sends the reason as the admin actor', (
    tester,
  ) async {
    final harness = await _pumpLoadedPage(tester, rows: harnessRows(count: 1));
    final reject = find.widgetWithText(OutlinedButton, 'Reddet');
    await tester.ensureVisible(reject);
    await tester.tap(reject);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextFormField),
      ),
      'Seçilen hizmet bu gün verilemiyor.',
    );
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('Reddet'),
      ),
    );
    await tester.pumpAndSettle();

    final changed = harness.appointments.stored['appointment-0'];
    expect(changed?.status, AppointmentStatus.rejected);
    expect(changed?.statusReason, 'Seçilen hizmet bu gün verilemiyor.');
    expect(changed?.history.last.byUserId, 'admin-1');
    expect(changed?.history.last.byRole, UserRole.admin);
    expect(find.text('Talep reddedildi.'), findsOneWidget);
  });

  testWidgets('approved row cancellation sends the reason as the admin actor', (
    tester,
  ) async {
    final harness = await _pumpLoadedPage(
      tester,
      rows: harnessRows(count: 1, pendingCount: 0),
    );
    final cancel = find.widgetWithText(OutlinedButton, 'İptal et');
    await tester.ensureVisible(cancel);
    await tester.tap(cancel);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.byType(TextFormField),
      ),
      'Hasta yeni bir tarih istedi.',
    );
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('İptal et'),
      ),
    );
    await tester.pumpAndSettle();

    final changed = harness.appointments.stored['appointment-0'];
    expect(changed?.status, AppointmentStatus.cancelledByStaff);
    expect(changed?.statusReason, 'Hasta yeni bir tarih istedi.');
    expect(changed?.history.last.byUserId, 'admin-1');
    expect(changed?.history.last.byRole, UserRole.admin);
    expect(find.text('Randevu iptal edildi.'), findsOneWidget);
  });

  testWidgets('appointment failure has a retry action', (tester) async {
    final harness = await _pumpPage(tester);
    await harness.loadCatalog(tester);
    expect(find.byType(LoadingState), findsOneWidget);
    await harness.failAppointments(tester);

    expect(find.text('Randevular yüklenemedi'), findsOneWidget);
    expect(find.text('Tekrar dene'), findsOneWidget);
  });

  testWidgets('catalog failure has a retry action', (tester) async {
    final harness = AdminAppointmentsPageHarness()
      ..catalogRepositories.staffSetupError = Exception('catalog failed');
    await harness.initialize();
    await harness.pumpPage(tester);
    addTearDown(() => harness.dispose(tester));

    expect(find.text('Kurum bilgileri yüklenemedi'), findsOneWidget);
    expect(find.text('Tekrar dene'), findsOneWidget);
  });
}

Finder get _table {
  return find.byWidgetPredicate((widget) => widget is AppDataTable);
}

Finder _paginationButton(String tooltip) {
  return find.byWidgetPredicate(
    (widget) => widget is IconButton && widget.tooltip == tooltip,
  );
}

Finder _statusChip(String label) {
  return find.descendant(
    of: find.byType(AppMultiFilterChips<AdminStatusFilter>),
    matching: find.text(label),
  );
}

Finder _selectField(int index) {
  return find
      .byWidgetPredicate((widget) => widget is DropdownButtonFormField<String?>)
      .at(index);
}

Future<AdminAppointmentsPageHarness> _pumpPage(
  WidgetTester tester, {
  Size size = AdminAppointmentsPageHarness.desktop,
}) async {
  final harness = AdminAppointmentsPageHarness();
  await harness.initialize();
  await harness.pumpPage(tester, size: size);
  addTearDown(() => harness.dispose(tester));
  return harness;
}

Future<AdminAppointmentsPageHarness> _pumpLoadedPage(
  WidgetTester tester, {
  required List<Appointment> rows,
  Size size = AdminAppointmentsPageHarness.desktop,
}) async {
  final harness = await _pumpPage(tester, size: size);
  await harness.loadData(tester, rows);
  return harness;
}

List<Appointment> harnessRows({required int count, int pendingCount = 1}) {
  return AdminAppointmentsPageHarness().appointmentRows(
    count: count,
    pendingCount: pendingCount,
  );
}
