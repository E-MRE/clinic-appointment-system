import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/enums/auth_form_kind.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/auth_form_config.dart';

/// Configuration and screen decisions of an [AuthFormKind].
extension AuthFormKindConfig on AuthFormKind {
  /// Labels, dimensions and layout decisions of this screen.
  AuthFormConfig get config {
    return switch (this) {
      AuthFormKind.signIn => const AuthFormConfig.signIn(),
      AuthFormKind.signUp => const AuthFormConfig.signUp(),
      AuthFormKind.passwordReset => const AuthFormConfig.passwordReset(),
    };
  }

  /// Whether this variant represents patient sign-up.
  bool get isRegistration => this == AuthFormKind.signUp;

  /// Whether this variant represents user sign-in.
  bool get isSignIn => this == AuthFormKind.signIn;

  /// Whether this variant represents password reset request.
  bool get isPasswordReset => this == AuthFormKind.passwordReset;

  /// Resolves the localized description key for the given viewport [size].
  String descriptionKeyFor(ScreenSize size) {
    final config = this.config;
    return size.select(
      mobile: config.mobileDescriptionKey ?? config.descriptionKey,
      tablet: config.tabletDescriptionKey ?? config.descriptionKey,
      desktop: config.descriptionKey,
    );
  }

  /// Whether this form should present a loading or disabled state for [state].
  bool isBusy(AuthRequestState state) {
    return state is AuthRequestLoading ||
        (state is AuthRequestSuccess && config.opensHomeOnSuccess);
  }
}
