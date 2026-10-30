import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/auth_form_kind_config.dart';
import 'package:clinic_appointment_system/features/auth/presentation/extensions/auth_location_form_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthFormKind', () {
    test('signIn defines self-contained configuration', () {
      const kind = AuthFormKind.signIn;

      expect(kind.isSignIn, isTrue);
      expect(kind.isRegistration, isFalse);
      expect(kind.isPasswordReset, isFalse);
      expect(kind.config.hasPassword, isTrue);
      expect(kind.config.offersBack, isFalse);
      expect(kind.config.opensHomeOnSuccess, isTrue);
      expect(kind.config.showsStaffNotice, isTrue);
      expect(kind.config.formWidth, AppSizes.authFormWidth);
      expect(kind.config.cardWidth, AppSizes.authCardWidth);
      expect(kind.config.footer.alternateRoute, AppRoutes.signUp);
      expect(kind.config.successMessageKey, isNull);
    });

    test('signUp defines self-contained registration configuration', () {
      const kind = AuthFormKind.signUp;

      expect(kind.isSignIn, isFalse);
      expect(kind.isRegistration, isTrue);
      expect(kind.isPasswordReset, isFalse);
      expect(kind.config.hasPassword, isTrue);
      expect(kind.config.offersBack, isTrue);
      expect(kind.config.opensHomeOnSuccess, isTrue);
      expect(kind.config.showsStaffNotice, isFalse);
      expect(kind.config.formWidth, AppSizes.registrationFormWidth);
      expect(kind.config.cardWidth, AppSizes.messageMaxWidth);
      expect(kind.config.footer.alternateRoute, AppRoutes.signIn);
      expect(kind.config.successMessageKey, isNull);
    });

    test('passwordReset defines self-contained reset configuration', () {
      const kind = AuthFormKind.passwordReset;

      expect(kind.isSignIn, isFalse);
      expect(kind.isRegistration, isFalse);
      expect(kind.isPasswordReset, isTrue);
      expect(kind.config.hasPassword, isFalse);
      expect(kind.config.offersBack, isTrue);
      expect(kind.config.opensHomeOnSuccess, isFalse);
      expect(kind.config.showsStaffNotice, isFalse);
      expect(kind.config.formWidth, AppSizes.authFormWidth);
      expect(kind.config.cardWidth, AppSizes.authCardWidth);
      expect(kind.config.footer.alternateRoute, AppRoutes.signIn);
      expect(kind.config.successMessageKey, LocaleKeys.auth_resetSent);
    });

    test('authFormKind resolves each route and falls back to sign-in', () {
      for (final kind in AuthFormKind.values) {
        expect(kind.config.location.authFormKind, kind);
      }
      expect('/unknown'.authFormKind, AuthFormKind.signIn);
    });

    test('descriptionKeyFor resolves responsive variant when provided', () {
      expect(
        AuthFormKind.signIn.descriptionKeyFor(ScreenSize.mobile),
        AuthFormKind.signIn.config.mobileDescriptionKey,
      );
      expect(
        AuthFormKind.signIn.descriptionKeyFor(ScreenSize.tablet),
        AuthFormKind.signIn.config.tabletDescriptionKey,
      );
      expect(
        AuthFormKind.signIn.descriptionKeyFor(ScreenSize.desktop),
        AuthFormKind.signIn.config.descriptionKey,
      );

      expect(
        AuthFormKind.passwordReset.descriptionKeyFor(ScreenSize.mobile),
        AuthFormKind.passwordReset.config.descriptionKey,
      );
    });

    test('isBusy checks loading and opensHomeOnSuccess behavior', () {
      const initial = AuthRequestInitial();
      const loading = AuthRequestLoading();
      const success = AuthRequestSuccess();
      const failure = AuthRequestFailure.message('error');

      expect(AuthFormKind.signIn.isBusy(initial), isFalse);
      expect(AuthFormKind.signIn.isBusy(loading), isTrue);
      expect(AuthFormKind.signIn.isBusy(success), isTrue);
      expect(AuthFormKind.signIn.isBusy(failure), isFalse);

      expect(AuthFormKind.signUp.isBusy(initial), isFalse);
      expect(AuthFormKind.signUp.isBusy(loading), isTrue);
      expect(AuthFormKind.signUp.isBusy(success), isTrue);
      expect(AuthFormKind.signUp.isBusy(failure), isFalse);

      expect(AuthFormKind.passwordReset.isBusy(initial), isFalse);
      expect(AuthFormKind.passwordReset.isBusy(loading), isTrue);
      expect(AuthFormKind.passwordReset.isBusy(success), isFalse);
      expect(AuthFormKind.passwordReset.isBusy(failure), isFalse);
    });
  });
}
