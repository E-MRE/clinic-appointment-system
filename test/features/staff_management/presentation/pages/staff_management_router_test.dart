import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/widgets/add_action/app_add_fab.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/pages/staff_home_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_form_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_management_page.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/widgets/staff_form.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_cubit_factory.dart';
import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/user_repository_double.dart';
import 'doubles/staff_page_harness.dart';

void main() {
  late StaffPageHarness harness;

  setUp(() async {
    harness = StaffPageHarness();
    await harness.initialize();
  });

  testWidgets(
    'admin shell exposes Personel and all staff routes remain inside admin',
    (tester) async {
      addTearDown(() => harness.dispose(tester));
      harness.registerAdminScope();
      final authRepository = MockAuthRepository();
      when(() => authRepository.authStateChanges()).thenAnswer(
        (_) => Stream.value(
          const DataResult.success(
            data: AuthSession(
              userId: 'admin',
              email: 'admin@clinic.com',
              isEmailVerified: true,
            ),
          ),
        ),
      );
      final users = TestUserRepository()
        ..getResult = const DataResult.success(
          data: Admin(
            id: 'admin',
            fullName: 'Admin',
            email: 'admin@clinic.com',
          ),
        );
      final auth = createAuthCubit(authRepository, users);
      await auth.stream.firstWhere((state) => state is AuthSignedIn);
      final guard = AuthRouteGuard(auth);
      final router = createAppRouter(
        initialLocation: AppRoutes.adminStaff,
        authGuard: guard,
      );
      addTearDown(() async {
        router.dispose();
        guard.dispose();
        await auth.close();
      });
      await harness.pumpRouter(tester, router);
      await harness.load(tester);
      expect(find.byType(StaffManagementPage), findsOneWidget);
      expect(find.text('Personel'), findsNWidgets(2));
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.adminStaff,
      );
      await tester.tap(find.byType(AppAddFab));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.adminStaffNew,
      );
      expect(find.byType(StaffFormPage), findsOneWidget);
      expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff, isNull);
      router.pop();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Ada Kaya'));
      await tester.pumpAndSettle();
      expect(
        router.routeInformationProvider.value.uri.path,
        AppRoutes.adminStaffEdit('ada'),
      );
      expect(tester.widget<StaffForm>(find.byType(StaffForm)).staff?.id, 'ada');
    },
  );

  for (final path in [
    AppRoutes.adminStaffNew,
    AppRoutes.adminStaffEdit('ada'),
  ]) {
    testWidgets('direct link $path creates route scope and renders form', (
      tester,
    ) async {
      addTearDown(() => harness.dispose(tester));
      harness.registerAdminScope();
      final router = createAppRouter(initialLocation: path);
      addTearDown(router.dispose);
      await harness.pumpRouter(tester, router);
      await harness.load(tester);
      expect(find.byType(StaffFormPage), findsOneWidget);
      expect(find.byType(StaffForm), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, path);
      expect(harness.departmentRepository.watchedBranchIds, [
        'branch',
        'second',
      ]);
    });
  }

  final List<User> staffUsers = [
    StaffPageHarness.fixtures.doctor(id: 'ada'),
    StaffPageHarness.fixtures.technician(id: 'ece'),
  ];
  for (final user in staffUsers) {
    testWidgets(
      '${user.role.name} keeps /staff home and cannot access admin staff',
      (tester) async {
        addTearDown(() => harness.dispose(tester));
        final authRepository = MockAuthRepository();
        when(() => authRepository.authStateChanges()).thenAnswer(
          (_) => Stream.value(
            DataResult.success(
              data: AuthSession(
                userId: user.id,
                email: user.email,
                isEmailVerified: true,
              ),
            ),
          ),
        );
        final users = TestUserRepository()
          ..getResult = DataResult.success(data: user);
        final auth = createAuthCubit(authRepository, users);
        await auth.stream.firstWhere((state) => state is AuthSignedIn);
        final guard = AuthRouteGuard(auth);
        final router = createAppRouter(
          initialLocation: AppRoutes.staffHome,
          authGuard: guard,
        );
        addTearDown(() async {
          router.dispose();
          guard.dispose();
          await auth.close();
        });
        await harness.pumpRouter(tester, router);
        expect(router.routeInformationProvider.value.uri.path, '/staff');
        expect(find.byType(StaffHomePage), findsOneWidget);
        router.go(AppRoutes.adminStaffEdit('ada'));
        await tester.pumpAndSettle();
        expect(router.routeInformationProvider.value.uri.path, '/staff');
        expect(find.byType(StaffHomePage), findsOneWidget);
      },
    );
  }
}
