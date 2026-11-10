import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/patient/presentation/pages/patient_appointments_page.dart';
import 'package:clinic_appointment_system/features/patient/presentation/pages/patient_book_page.dart';
import 'package:clinic_appointment_system/features/patient/presentation/widgets/patient_shell.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../doubles/patient_page_harness.dart';

void main() {
  late PatientPageHarness harness;

  setUp(() async {
    harness = PatientPageHarness();
    await harness.initialize();
  });

  for (final size in [
    PatientPageHarness.mobile,
    PatientPageHarness.tablet,
    PatientPageHarness.desktop,
  ]) {
    testWidgets('patient home opens appointments inside the shell at $size', (
      tester,
    ) async {
      addTearDown(() => harness.dispose(tester));
      final guard = AuthRouteGuard(harness.auth);
      final router = createAppRouter(
        initialLocation: AppRoutes.patientHome,
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
        AppRoutes.patientAppointments,
      );
      expect(find.byType(PatientShell), findsOneWidget);
      expect(find.byType(PatientAppointmentsPage), findsOneWidget);
      final shell = tester.element(find.byType(PatientShell));

      await tester.tap(find.text('Randevu al').first);
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.patientBook,
      );
      expect(find.byType(PatientBookPage), findsOneWidget);
      expect(tester.element(find.byType(PatientShell)), same(shell));

      router.go(AppRoutes.adminStaff);
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.patientAppointments,
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('desktop user card shows the patient and signs out', (
    tester,
  ) async {
    addTearDown(() => harness.dispose(tester));
    final router = createAppRouter(
      initialLocation: AppRoutes.patientAppointments,
    );
    addTearDown(router.dispose);
    await harness.pumpRouter(tester, router);
    expect(find.byType(AppNavigationUserCard), findsOneWidget);
    expect(find.text('EK'), findsOneWidget);
    expect(find.text('Elif Kaya'), findsOneWidget);
    expect(find.text('Hasta'), findsOneWidget);
    await tester.tap(find.byTooltip('Çıkış yap'));
    await harness.flush(tester);
    verify(() => harness.authRepository.signOut()).called(1);
  });
}
