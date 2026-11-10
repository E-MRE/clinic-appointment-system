import 'dart:async';

import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../appointments/domain/support/appointment_fixture.dart';
import 'doubles/staff_requests_page_harness.dart';

void main() {
  const fixture = AppointmentFixture();
  final request = fixture.request().withId('request-17');
  late StaffRequestsPageHarness harness;

  setUp(() async {
    harness = StaffRequestsPageHarness();
    await harness.initialize();
  });

  testWidgets(
    'lists pending service requests and approves as signed-in staff',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      await harness.pump(tester, size: StaffRequestsPageHarness.mobile);
      await harness.emitAndPump(tester, [request]);

      expect(find.text('Talepler'), findsOneWidget);
      expect(find.text('Onay bekleyen randevu talepleri.'), findsOneWidget);
      expect(find.text(request.serviceName), findsOneWidget);
      expect(find.text('Beklemede'), findsOneWidget);
      expect(find.text('Onayla'), findsOneWidget);
      expect(find.text(request.patientId), findsNothing);
      expect(tester.takeException(), isNull);

      await tester.tap(find.text('Onayla'));
      await tester.pumpAndSettle();

      expect(harness.repository.changedIds, [request.id]);
      expect(
        harness.repository.stored[request.id]?.status,
        AppointmentStatus.approved,
      );
      expect(
        harness.repository.stored[request.id]?.history.last.byUserId,
        harness.staff.id,
      );
      expect(find.text('Randevu onaylandı.'), findsOneWidget);
    },
  );

  testWidgets('shows approval progress and a localized failure', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    final pending = Completer<AppointmentResult>();
    harness.repository.pendingChange = pending;
    await harness.pump(tester, size: StaffRequestsPageHarness.mobile);
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

  testWidgets('shows the empty state when no request awaits approval', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    await harness.pump(tester, size: StaffRequestsPageHarness.mobile);
    await harness.emitAndPump(tester, []);

    expect(find.text('Onay bekleyen talep yok.'), findsOneWidget);
    expect(find.text('Onayla'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps request rows within mobile, tablet and desktop widths', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    const sizes = [
      StaffRequestsPageHarness.mobile,
      StaffRequestsPageHarness.tablet,
      StaffRequestsPageHarness.desktop,
    ];
    for (final size in sizes) {
      await harness.pump(tester, size: size);
      await harness.emitAndPump(tester, [request]);

      expect(find.text(request.serviceName), findsOneWidget);
      expect(find.text('Onayla'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });

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
    expect(find.byIcon(Icons.inbox), findsOneWidget);
    expect(find.text('Talepler'), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}
