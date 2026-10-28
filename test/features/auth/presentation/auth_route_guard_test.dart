import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../support/auth_cubit_factory.dart';
import '../../../support/auth_repository_doubles.dart';
import '../../../support/user_repository_double.dart';

class _Context extends Mock implements BuildContext {}

class _Route extends Mock implements GoRouterState {}

void main() {
  const session = AuthSession(
    userId: 'id',
    email: 'a@example.com',
    isEmailVerified: false,
  );
  const roles = [
    (Patient(id: 'id', fullName: 'A', email: 'a@example.com'), '/patient'),
    (
      Doctor(
        id: 'id',
        fullName: 'A',
        email: 'a@example.com',
        branchId: 'b',
        departmentId: 'd',
      ),
      '/staff',
    ),
    (
      Technician(
        id: 'id',
        fullName: 'A',
        email: 'a@example.com',
        branchId: 'b',
        departmentId: 'd',
      ),
      '/staff',
    ),
    (Admin(id: 'id', fullName: 'A', email: 'a@example.com'), '/admin'),
  ];
  const homes = [
    '/',
    '/patient',
    '/patient/appointments',
    '/staff',
    '/staff/schedule',
    '/admin',
    '/admin/institution',
    '/admin/institution/clinics/clinic-2/branches/branch-2',
  ];
  const auth = ['/sign-in', '/sign-in/register', '/sign-in/reset-password'];
  const unchanged = ['/debug/components', '/missing', '/other/path'];

  test('signed-out users are redirected from every home only', () async {
    final repository = MockAuthRepository();
    when(() => repository.authStateChanges()).thenAnswer(
      (_) => Stream.value(const DataResult<AuthSession>.success(data: null)),
    );
    final cubit = createAuthCubit(repository, TestUserRepository());
    await cubit.stream.firstWhere((state) => state is AuthSignedOut);
    final guard = AuthRouteGuard(cubit);
    final route = _Route();
    for (final path in homes) {
      when(() => route.uri).thenReturn(Uri.parse(path));
      expect(guard.redirect(_Context(), route), '/sign-in', reason: path);
    }
    for (final path in [...auth, ...unchanged]) {
      when(() => route.uri).thenReturn(Uri.parse(path));
      expect(guard.redirect(_Context(), route), isNull, reason: path);
    }
    guard.dispose();
    await cubit.close();
  });

  for (final (user, home) in roles) {
    test(
      '${user.role} is routed to $home and cannot open other homes',
      () async {
        final repository = MockAuthRepository();
        when(() => repository.authStateChanges()).thenAnswer(
          (_) => Stream.value(const DataResult.success(data: session)),
        );
        final users = TestUserRepository()
          ..getResult = DataResult.success(data: user);
        final cubit = createAuthCubit(repository, users);
        await cubit.stream.firstWhere((state) => state is AuthSignedIn);
        final guard = AuthRouteGuard(cubit);
        final route = _Route();
        for (final path in [...homes, ...auth]) {
          when(() => route.uri).thenReturn(Uri.parse(path));
          expect(
            guard.redirect(_Context(), route),
            path == home || path.startsWith('$home/') ? null : home,
            reason: path,
          );
        }
        for (final path in unchanged) {
          when(() => route.uri).thenReturn(Uri.parse(path));
          expect(guard.redirect(_Context(), route), isNull, reason: path);
        }
        guard.dispose();
        await cubit.close();
      },
    );
  }
}
