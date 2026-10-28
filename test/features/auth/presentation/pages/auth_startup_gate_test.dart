import 'dart:async';

import 'package:clinic_appointment_system/app.dart';
import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/register_patient_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/send_password_reset_email_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/usecases/sign_in_use_case.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_cubit_factory.dart';
import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/localization_test_app.dart';
import '../../../../support/user_repository_double.dart';

void main() {
  late MockAuthRepository repository;
  late StreamController<DataResult<AuthSession>> controller;
  late AuthCubit authCubit;
  late TestUserRepository users;
  late ThemeCubit themeCubit;
  late GoRouter router;
  setUp(() {
    repository = MockAuthRepository();
    controller = StreamController<DataResult<AuthSession>>();
    when(
      () => repository.authStateChanges(),
    ).thenAnswer((_) => controller.stream);
    users = TestUserRepository();
    authCubit = createAuthCubit(repository, users);
    AppDependency.injector.registerFactory<SignInCubit>(
      () => SignInCubit(SignInUseCase(repository)),
    );
    AppDependency.injector.registerFactory<SignUpCubit>(
      () => SignUpCubit(RegisterPatientUseCase(repository, users)),
    );
    AppDependency.injector.registerFactory<PasswordResetCubit>(
      () => PasswordResetCubit(SendPasswordResetEmailUseCase(repository)),
    );
    themeCubit = ThemeCubit();
    router = createAppRouter();
  });
  tearDown(() async {
    await authCubit.close();
    await themeCubit.close();
    await controller.close();
    router.dispose();
    await AppDependency.injector.reset();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    tester.platformDispatcher.accessibilityFeaturesTestValue =
        const FakeAccessibilityFeatures(disableAnimations: true);
    addTearDown(tester.platformDispatcher.clearAccessibilityFeaturesTestValue);
    await pumpLocalizedWidget(
      tester,
      App(router: router, themeCubit: themeCubit, authCubit: authCubit),
    );
    await tester.pump();
  }

  Future<void> settle(WidgetTester tester) async {
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  testWidgets('missing profile explains the failure and offers sign out', (
    tester,
  ) async {
    users.profileStream = Stream.error(
      const UserException(UserErrorCode.profileMissing),
    );
    when(
      () => repository.signOut(),
    ).thenAnswer((_) async => const Result.success());
    await pumpApp(tester);
    controller.add(
      const DataResult.success(
        data: AuthSession(
          userId: 'patient-1',
          email: 'patient@example.com',
          isEmailVerified: false,
        ),
      ),
    );
    await settle(tester);
    expect(
      find.text(
        'Hesabınızın profili bulunamadı. Klinik yönetimiyle iletişime geçin.',
      ),
      findsOneWidget,
    );
    await tester.tap(find.text('Çıkış yap'));
    await tester.pump();
    verify(() => repository.signOut()).called(1);
  });

  for (final path in [
    AppRoutes.signIn,
    AppRoutes.signUp,
    AppRoutes.passwordReset,
  ]) {
    testWidgets('missing profile keeps auth route $path visible', (
      tester,
    ) async {
      router.dispose();
      router = createAppRouter(initialLocation: path);
      users.profileStream = Stream.error(
        const UserException(UserErrorCode.profileMissing),
      );
      await pumpApp(tester);
      controller.add(
        const DataResult.success(
          data: AuthSession(
            userId: 'patient-1',
            email: 'patient@example.com',
            isEmailVerified: false,
          ),
        ),
      );
      await settle(tester);
      expect(router.routeInformationProvider.value.uri.path, path);
      expect(find.byKey(const WidgetKey.startupErrorPage()), findsNothing);
      router.go(AppRoutes.home);
      await settle(tester);
      expect(find.byKey(const WidgetKey.startupErrorPage()), findsOneWidget);
    });
  }

  testWidgets('invalid profile shows recovery on an auth route', (
    tester,
  ) async {
    router.dispose();
    router = createAppRouter(initialLocation: AppRoutes.signUp);
    users.profileStream = Stream.error(
      const UserException(UserErrorCode.invalidProfile),
    );
    await pumpApp(tester);
    controller.add(
      const DataResult.success(
        data: AuthSession(
          userId: 'patient-1',
          email: 'patient@example.com',
          isEmailVerified: false,
        ),
      ),
    );
    await settle(tester);
    expect(find.byKey(const WidgetKey.startupErrorPage()), findsOneWidget);
  });

  testWidgets('Splash remains visible until session restoration finishes', (
    tester,
  ) async {
    await pumpApp(tester);
    await tester.pump(const Duration(seconds: 2));
    expect(find.byKey(const WidgetKey.splashPage()), findsOneWidget);
    expect(find.byKey(const WidgetKey.themeToggleKey()), findsNothing);
    controller.add(const DataResult.success(data: null));
    await settle(tester);
    expect(find.byKey(const WidgetKey.splashPage()), findsNothing);
    expect(find.byKey(const WidgetKey.themeToggleKey()), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('restored signed-in sessions reveal the current route', (
    tester,
  ) async {
    await pumpApp(tester);
    controller.add(
      const DataResult.success(
        data: AuthSession(
          userId: 'patient-1',
          email: 'patient@example.com',
          isEmailVerified: false,
        ),
      ),
    );
    await settle(tester);
    expect(find.byKey(const WidgetKey.splashPage()), findsNothing);
    expect(find.byKey(const WidgetKey.themeToggleKey()), findsOneWidget);
  });

  testWidgets(
    'resizing updates typography without restarting session restoration',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await pumpApp(tester);
      await tester.pumpAndSettle();
      final mobileTitle = tester
          .widget<Text>(find.text('Klinik Randevu Sistemi'))
          .style;
      tester.view.physicalSize = const Size(1440, 900);
      await tester.pumpAndSettle();
      final desktopTitle = tester
          .widget<Text>(find.text('Klinik Randevu Sistemi'))
          .style;
      expect(mobileTitle?.fontSize, isNotNull);
      expect(desktopTitle?.fontSize, greaterThan(mobileTitle?.fontSize ?? 0));
      expect(desktopTitle?.fontFamily, mobileTitle?.fontFamily);
      verify(() => repository.authStateChanges()).called(1);
      controller.add(const DataResult.success(data: null));
      await settle(tester);
      expect(find.byKey(const WidgetKey.splashPage()), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'unknown deep links survive Splash and show the existing not-found route',
    (tester) async {
      router.dispose();
      router = createAppRouter(initialLocation: '/missing?source=bookmark');
      await pumpApp(tester);
      controller.add(const DataResult.success(data: null));
      await settle(tester);
      expect(find.text('Sayfa bulunamadı'), findsOneWidget);
      expect(router.routeInformationProvider.value.uri.path, '/missing');
    },
  );

  testWidgets(
    'offline startup shows the localized error and retry reconnects',
    (tester) async {
      await pumpApp(tester);
      controller.addError(
        const AuthException(AuthErrorCode.networkRequestFailed),
      );
      await settle(tester);
      expect(authCubit.state, isA<AuthFailure>());
      expect(find.text('Bağlantı kurulamadı'), findsOneWidget);
      expect(find.byKey(const WidgetKey.startupErrorPage()), findsOneWidget);
      when(() => repository.authStateChanges()).thenAnswer(
        (_) => Stream.value(const DataResult<AuthSession>.success(data: null)),
      );
      await tester.tap(find.byKey(const WidgetKey.startupRetry()));
      await settle(tester);
      expect(controller.hasListener, isFalse);
      expect(find.byKey(const WidgetKey.startupErrorPage()), findsNothing);
      expect(find.byKey(const WidgetKey.themeToggleKey()), findsOneWidget);
    },
  );

  testWidgets('unexpected startup errors show the generic recovery screen', (
    tester,
  ) async {
    await pumpApp(tester);
    controller.addError(const AuthException(AuthErrorCode.unexpected));
    await settle(tester);
    expect(find.text('Bir şeyler ters gitti'), findsOneWidget);
    expect(find.text('Ana sayfaya dön'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('return home resets the route and retries the session', (
    tester,
  ) async {
    router.dispose();
    router = createAppRouter(initialLocation: '/missing');
    await pumpApp(tester);
    controller.addError(const AuthException(AuthErrorCode.unexpected));
    await settle(tester);
    when(() => repository.authStateChanges()).thenAnswer(
      (_) => Stream.value(const DataResult<AuthSession>.success(data: null)),
    );
    await tester.tap(find.text('Ana sayfaya dön'));
    await settle(tester);
    expect(router.routeInformationProvider.value.uri.path, '/');
    expect(find.byKey(const WidgetKey.themeToggleKey()), findsOneWidget);
  });
}
