import 'dart:async';

import 'package:clinic_appointment_system/app.dart';
import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_credentials.dart';
import 'package:clinic_appointment_system/features/auth/domain/models/auth_registration.dart';
import 'package:clinic_appointment_system/features/auth/presentation/auth_route_guard.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/password_reset_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_in_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/sign_up_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/auth_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/password_reset_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/sign_in_page.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/auth_repository_doubles.dart';
import '../../../../support/localization_test_app.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(
      const AuthRegistration(
        fullName: 'Elif Kaya',
        email: 'a@example.com',
        password: 'secret12',
      ),
    );
  });

  testWidgets(
    'registration stacks on sign-in and back returns to the same form',
    (tester) async {
      final app = await _pump(tester);
      expect(find.byType(SignInPage), findsOneWidget);
      final signIn = app.signInCubits.single;
      await tester.enterText(
        find.byKey(const WidgetKey.authEmail()),
        'patient@example.com',
      );
      await tester.tap(find.text('Hasta olarak kayıt olun'));
      await tester.pumpAndSettle();
      expect(find.byType(SignUpPage), findsOneWidget);
      expect(signIn.isClosed, isFalse);
      await tester.tap(find.byTooltip('Geri'));
      await tester.pumpAndSettle();
      expect(find.byType(SignUpPage), findsNothing);
      expect(app.signInCubits.single, same(signIn));
      expect(find.text('patient@example.com'), findsOneWidget);
    },
  );

  testWidgets('system back pops password reset to sign-in', (tester) async {
    final app = await _pump(tester);
    await tester.tap(find.text('Şifremi unuttum'));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordResetPage), findsOneWidget);
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(find.byType(PasswordResetPage), findsNothing);
    expect(find.byType(SignInPage), findsOneWidget);
    expect(app.signInCubits.length, 1);
  });

  testWidgets('desktop brand panel stays while the form changes', (
    tester,
  ) async {
    await _pump(tester, size: const Size(1440, 900));
    final shell = tester.element(find.byType(AuthShell));
    await tester.tap(find.text('Hasta olarak kayıt olun'));
    await tester.pumpAndSettle();
    expect(find.byType(SignUpPage), findsOneWidget);
    expect(tester.element(find.byType(AuthShell)), same(shell));
    expect(find.text('Üç adımda randevu.'), findsOneWidget);
  });

  testWidgets('leaving auth for home closes the stacked request Cubits', (
    tester,
  ) async {
    final app = await _pump(tester);
    await tester.tap(find.text('Hasta olarak kayıt olun'));
    await tester.pumpAndSettle();
    app.sessions.add(const DataResult.success(data: _session));
    await tester.pumpAndSettle();
    app.router.go(AppRoutes.home);
    await tester.pumpAndSettle();
    expect(find.byType(AuthShell), findsNothing);
    expect(app.signInCubits.single.isClosed, isTrue);
  });

  testWidgets(
    'registration password Next moves to confirmation without submitting',
    (tester) async {
      final app = await _pump(tester, route: AppRoutes.signUp);
      await tester.enterText(
        find.byKey(const WidgetKey.authFullName()),
        'Elif Kaya',
      );
      await _credentials(tester);
      await tester.showKeyboard(find.byKey(const WidgetKey.authPassword()));
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pumpAndSettle();
      expect(find.text('Şifreler eşleşmiyor.'), findsNothing);
      verifyNever(() => app.repository.signUp(any()));
    },
  );

  testWidgets('keyboard insets keep registration submit reachable', (
    tester,
  ) async {
    await _pump(tester, route: AppRoutes.signUp);
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    addTearDown(tester.view.resetViewInsets);
    await tester.tap(find.byKey(const WidgetKey.authEmail()));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const WidgetKey.authSubmit()));
    expect(tester.takeException(), isNull);
  });

  testWidgets('restored session stays home and sign-out reopens sign-in', (
    tester,
  ) async {
    final app = await _pump(tester);
    app.sessions.add(const DataResult.success(data: _session));
    await tester.pumpAndSettle();
    app.router.go(AppRoutes.home);
    await tester.pumpAndSettle();
    expect(find.byType(SignInPage), findsNothing);
    app.sessions.add(const DataResult.success(data: null));
    await tester.pumpAndSettle();
    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets(
    'sign-in accepts existing short passwords and waits for session',
    (tester) async {
      final app = await _pump(tester);
      final pending = Completer<DataResult<AuthSession>>();
      when(
        () => app.repository.signIn(any()),
      ).thenAnswer((_) => pending.future);
      await _credentials(tester, password: 'old');
      await _submit(tester);
      await tester.pump();
      expect(
        tester
            .widget<FilledButton>(find.byKey(const WidgetKey.authSubmit()))
            .onPressed,
        isNull,
      );
      pending.complete(const DataResult.success(data: _session));
      await tester.pump();
      expect(find.byType(SignInPage), findsOneWidget);
      app.sessions.add(const DataResult.success(data: _session));
      await tester.pumpAndSettle();
      expect(
        app.router.routeInformationProvider.value.uri.path,
        AppRoutes.home,
      );
      final credentials =
          verify(() => app.repository.signIn(captureAny())).captured.single
              as AuthCredentials;
      expect(credentials.password, 'old');
    },
  );

  testWidgets(
    'sign-in localizes Firebase errors and preserves input for retry',
    (tester) async {
      final app = await _pump(tester);
      when(
        () => app.repository.signIn(any()),
      ).thenThrow(const AuthException(AuthErrorCode.invalidCredentials));
      await _credentials(tester);
      await _submit(tester);
      await tester.pumpAndSettle();
      expect(
        find.text(
          'E-posta adresi veya şifre hatalı. Bilgilerinizi kontrol edin.',
        ),
        findsOneWidget,
      );
      expect(
        tester
            .widget<TextFormField>(find.byKey(const WidgetKey.authEmail()))
            .controller!
            .text,
        'patient@example.com',
      );
      await tester.tap(find.byTooltip('Şifreyi göster'));
      await tester.pump();
      expect(
        tester
            .widget<TextField>(
              find.descendant(
                of: find.byKey(const WidgetKey.authPassword()),
                matching: find.byType(TextField),
              ),
            )
            .obscureText,
        isFalse,
      );
    },
  );

  testWidgets('registration validates confirmation and submits the full name', (
    tester,
  ) async {
    final app = await _pump(tester, route: AppRoutes.signUp);
    final pending = Completer<DataResult<AuthSession>>();
    when(() => app.repository.signUp(any())).thenAnswer((_) => pending.future);
    await tester.enterText(
      find.byKey(const WidgetKey.authFullName()),
      'Elif Kaya',
    );
    await _credentials(tester);
    await tester.enterText(
      find.byKey(const WidgetKey.authConfirmation()),
      'different',
    );
    await _submit(tester);
    await tester.pumpAndSettle();
    expect(find.text('Şifreler eşleşmiyor.'), findsOneWidget);
    verifyNever(() => app.repository.signUp(any()));
    await tester.enterText(
      find.byKey(const WidgetKey.authConfirmation()),
      'secret12',
    );
    await _submit(tester);
    app.sessions.add(const DataResult.success(data: _session));
    await tester.pump();
    expect(find.byType(SignUpPage), findsOneWidget);
    pending.complete(const DataResult.success(data: _session));
    await tester.pumpAndSettle();
    expect(app.router.routeInformationProvider.value.uri.path, AppRoutes.home);
    final registration =
        verify(() => app.repository.signUp(captureAny())).captured.single
            as AuthRegistration;
    expect(registration.fullName, 'Elif Kaya');
  });

  testWidgets(
    'profile failure stays visible even after the early sign-in event',
    (tester) async {
      final app = await _pump(tester, route: AppRoutes.signUp);
      when(() => app.repository.signUp(any())).thenAnswer((_) async {
        app.sessions.add(const DataResult.success(data: _session));
        throw const AuthException(AuthErrorCode.profileUpdateFailed);
      });
      await tester.enterText(
        find.byKey(const WidgetKey.authFullName()),
        'Elif Kaya',
      );
      await _credentials(tester);
      await tester.enterText(
        find.byKey(const WidgetKey.authConfirmation()),
        'secret12',
      );
      await _submit(tester);
      await tester.pumpAndSettle();
      expect(find.byType(SignUpPage), findsOneWidget);
      expect(
        find.textContaining('Hesabınız oluşturuldu ancak'),
        findsOneWidget,
      );
    },
  );

  testWidgets('forgot password sends an email and keeps confirmation private', (
    tester,
  ) async {
    final app = await _pump(tester);
    when(
      () => app.repository.sendPasswordResetEmail(any()),
    ).thenAnswer((_) async => const Result.success());
    await tester.tap(find.text('Şifremi unuttum'));
    await tester.pumpAndSettle();
    expect(find.byType(PasswordResetPage), findsOneWidget);
    await tester.enterText(
      find.byKey(const WidgetKey.authEmail()),
      'patient@example.com',
    );
    await _submit(tester);
    await tester.pumpAndSettle();
    expect(find.textContaining('Bu adresle bir hesap varsa'), findsOneWidget);
    verify(
      () => app.repository.sendPasswordResetEmail('patient@example.com'),
    ).called(1);
  });

  for (final route in [AppRoutes.signIn, AppRoutes.signUp]) {
    for (final size in [
      const Size(320, 568),
      const Size(834, 1194),
      const Size(1440, 900),
      const Size(900, 400),
    ]) {
      testWidgets('$route renders at $size with large text and dark theme', (
        tester,
      ) async {
        await _pump(
          tester,
          route: route,
          size: size,
          largeText: true,
          dark: true,
        );
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.byKey(const WidgetKey.authSubmit()));
        expect(tester.takeException(), isNull);
      });
    }
  }
}

const _session = AuthSession(
  userId: 'patient-1',
  email: 'patient@example.com',
  isEmailVerified: false,
);

Future<void> _credentials(
  WidgetTester tester, {
  String password = 'secret12',
}) async {
  await tester.enterText(
    find.byKey(const WidgetKey.authEmail()),
    'patient@example.com',
  );
  await tester.enterText(find.byKey(const WidgetKey.authPassword()), password);
}

Future<void> _submit(WidgetTester tester) async {
  final button = find.byKey(const WidgetKey.authSubmit());
  await tester.ensureVisible(button);
  await tester.tap(button);
}

Future<_AuthTestApp> _pump(
  WidgetTester tester, {
  String route = AppRoutes.home,
  Size size = const Size(390, 844),
  bool largeText = false,
  bool dark = false,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  if (largeText) tester.platformDispatcher.textScaleFactorTestValue = 2;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
  final app = _AuthTestApp(route);
  if (dark) app.themeCubit.toggle();
  addTearDown(app.dispose);
  await pumpLocalizedWidget(
    tester,
    App(
      router: app.router,
      themeCubit: app.themeCubit,
      authCubit: app.authCubit,
    ),
  );
  await tester.pumpAndSettle();
  return app;
}

final class _AuthTestApp {
  _AuthTestApp(String route) {
    when(
      () => repository.authStateChanges(),
    ).thenAnswer((_) => sessions.stream);
    authCubit = AuthCubit(repository);
    configuration = AuthRouteGuard(authCubit);
    router = createAppRouter(
      initialLocation: route,
      authGuard: configuration,
      signInCubitFactory: () {
        final cubit = SignInCubit(repository);
        signInCubits.add(cubit);
        return cubit;
      },
      signUpCubitFactory: () {
        return SignUpCubit(repository);
      },
      passwordResetCubitFactory: () {
        return PasswordResetCubit(repository);
      },
    );
    sessions.add(const DataResult.success(data: null));
  }
  final repository = MockAuthRepository();
  final sessions = StreamController<DataResult<AuthSession>>();
  final themeCubit = ThemeCubit();
  final signInCubits = <SignInCubit>[];
  late final AuthCubit authCubit;
  late final AuthRouteGuard configuration;
  late final GoRouter router;

  Future<void> dispose() async {
    router.dispose();
    configuration.dispose();
    await authCubit.close();
    await themeCubit.close();
    await sessions.close();
  }
}
