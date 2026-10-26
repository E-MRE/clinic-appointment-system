import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthFormKind', () {
    test('signIn defines self-contained configuration', () {
      const kind = AuthFormKind.signIn;

      expect(kind.isSignIn, isTrue);
      expect(kind.isRegistration, isFalse);
      expect(kind.isPasswordReset, isFalse);
      expect(kind.hasPassword, isTrue);
      expect(kind.offersBack, isFalse);
      expect(kind.opensHomeOnSuccess, isTrue);
      expect(kind.showsStaffNotice, isTrue);
      expect(kind.formWidth, AppSizes.authFormWidth);
      expect(kind.cardWidth, AppSizes.authCardWidth);
      expect(kind.footer.alternateRoute, AppRoutes.signUp);
      expect(kind.successMessageKey, isNull);
    });

    test('signUp defines self-contained registration configuration', () {
      const kind = AuthFormKind.signUp;

      expect(kind.isSignIn, isFalse);
      expect(kind.isRegistration, isTrue);
      expect(kind.isPasswordReset, isFalse);
      expect(kind.hasPassword, isTrue);
      expect(kind.offersBack, isTrue);
      expect(kind.opensHomeOnSuccess, isTrue);
      expect(kind.showsStaffNotice, isFalse);
      expect(kind.formWidth, AppSizes.registrationFormWidth);
      expect(kind.cardWidth, AppSizes.messageMaxWidth);
      expect(kind.footer.alternateRoute, AppRoutes.signIn);
      expect(kind.successMessageKey, isNull);
    });

    test('passwordReset defines self-contained reset configuration', () {
      const kind = AuthFormKind.passwordReset;

      expect(kind.isSignIn, isFalse);
      expect(kind.isRegistration, isFalse);
      expect(kind.isPasswordReset, isTrue);
      expect(kind.hasPassword, isFalse);
      expect(kind.offersBack, isTrue);
      expect(kind.opensHomeOnSuccess, isFalse);
      expect(kind.showsStaffNotice, isFalse);
      expect(kind.formWidth, AppSizes.authFormWidth);
      expect(kind.cardWidth, AppSizes.authCardWidth);
      expect(kind.footer.alternateRoute, AppRoutes.signIn);
      expect(kind.successMessageKey, LocaleKeys.auth_resetSent);
    });

    test('fromLocation resolves each route and falls back to sign-in', () {
      for (final kind in AuthFormKind.values) {
        expect(AuthFormKind.fromLocation(kind.location), kind);
      }
      expect(AuthFormKind.fromLocation('/unknown'), AuthFormKind.signIn);
    });

    test('descriptionKeyFor resolves responsive variant when provided', () {
      expect(
        AuthFormKind.signIn.descriptionKeyFor(ScreenSize.mobile),
        AuthFormKind.signIn.mobileDescriptionKey,
      );
      expect(
        AuthFormKind.signIn.descriptionKeyFor(ScreenSize.tablet),
        AuthFormKind.signIn.tabletDescriptionKey,
      );
      expect(
        AuthFormKind.signIn.descriptionKeyFor(ScreenSize.desktop),
        AuthFormKind.signIn.descriptionKey,
      );

      expect(
        AuthFormKind.passwordReset.descriptionKeyFor(ScreenSize.mobile),
        AuthFormKind.passwordReset.descriptionKey,
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
