import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_request_state.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/auth_footer_config.dart';

/// Labels, dimensions, and layout decisions for authentication screen variants.
enum AuthFormKind {
  signIn(
    location: AppRoutes.signIn,
    titleKey: LocaleKeys.auth_signInTitle,
    actionKey: LocaleKeys.auth_signInAction,
    descriptionKey: LocaleKeys.auth_signInDescriptionDesktop,
    brandTitleKey: LocaleKeys.auth_signInBrandTitle,
    mobileDescriptionKey: LocaleKeys.auth_signInDescriptionMobile,
    tabletDescriptionKey: LocaleKeys.auth_signInDescriptionTablet,
    formWidth: AppSizes.authFormWidth,
    cardWidth: AppSizes.authCardWidth,
    hasPassword: true,
    offersBack: false,
    opensHomeOnSuccess: true,
    showsStaffNotice: true,
    footer: AuthFooterConfig(
      promptKey: LocaleKeys.auth_noAccount,
      actionKey: LocaleKeys.auth_registerPatient,
      alternateRoute: AppRoutes.signUp,
    ),
  ),
  signUp(
    location: AppRoutes.signUp,
    titleKey: LocaleKeys.auth_signUpTitle,
    actionKey: LocaleKeys.auth_signUpTitle,
    descriptionKey: LocaleKeys.auth_signUpDescriptionDesktop,
    brandTitleKey: LocaleKeys.auth_signUpBrandTitle,
    mobileDescriptionKey: LocaleKeys.auth_signUpDescriptionMobile,
    tabletDescriptionKey: LocaleKeys.auth_signUpDescriptionTablet,
    formWidth: AppSizes.registrationFormWidth,
    cardWidth: AppSizes.messageMaxWidth,
    hasPassword: true,
    offersBack: true,
    opensHomeOnSuccess: true,
    showsStaffNotice: false,
    footer: AuthFooterConfig(
      promptKey: LocaleKeys.auth_hasAccount,
      actionKey: LocaleKeys.auth_signInTitle,
      alternateRoute: AppRoutes.signIn,
    ),
  ),
  passwordReset(
    location: AppRoutes.passwordReset,
    titleKey: LocaleKeys.auth_resetTitle,
    actionKey: LocaleKeys.auth_resetAction,
    descriptionKey: LocaleKeys.auth_resetDescription,
    brandTitleKey: LocaleKeys.auth_signInBrandTitle,
    formWidth: AppSizes.authFormWidth,
    cardWidth: AppSizes.authCardWidth,
    hasPassword: false,
    offersBack: true,
    opensHomeOnSuccess: false,
    showsStaffNotice: false,
    successMessageKey: LocaleKeys.auth_resetSent,
    footer: AuthFooterConfig(
      promptKey: LocaleKeys.auth_hasAccount,
      actionKey: LocaleKeys.auth_signInTitle,
      alternateRoute: AppRoutes.signIn,
    ),
  );

  const AuthFormKind({
    required this.location,
    required this.titleKey,
    required this.actionKey,
    required this.descriptionKey,
    required this.brandTitleKey,
    required this.formWidth,
    required this.cardWidth,
    required this.hasPassword,
    required this.offersBack,
    required this.opensHomeOnSuccess,
    required this.showsStaffNotice,
    required this.footer,
    this.mobileDescriptionKey,
    this.tabletDescriptionKey,
    this.successMessageKey,
  });

  /// Resolves the variant shown at [location], falling back to sign-in.
  factory AuthFormKind.fromLocation(String location) {
    return values.firstWhere(
      (kind) {
        return kind.location == location;
      },
      orElse: () {
        return signIn;
      },
    );
  }

  /// Route location that shows this screen.
  final String location;

  /// Translation key for the screen title.
  final String titleKey;

  /// Translation key for the primary submit action.
  final String actionKey;

  /// Translation key for the desktop description.
  final String descriptionKey;

  /// Translation key for the brand message on tablet and desktop.
  final String brandTitleKey;

  /// Translation key for the mobile description variant.
  final String? mobileDescriptionKey;

  /// Translation key for the tablet description variant.
  final String? tabletDescriptionKey;

  /// Maximum form content width.
  final double formWidth;

  /// Maximum card width on tablet viewports.
  final double cardWidth;

  /// Whether this screen requires a password field.
  final bool hasPassword;

  /// Whether the navigation bar displays a back button.
  final bool offersBack;

  /// Whether success opens home once signed in, keeping the form locked meanwhile.
  final bool opensHomeOnSuccess;

  /// Whether to display the staff portal notice at the footer.
  final bool showsStaffNotice;

  /// Footer navigation configuration.
  final AuthFooterConfig footer;

  /// Translation key announced after a successful request that stays on screen.
  final String? successMessageKey;

  /// Whether this variant represents patient sign-up.
  bool get isRegistration {
    return this == signUp;
  }

  /// Whether this variant represents user sign-in.
  bool get isSignIn {
    return this == signIn;
  }

  /// Whether this variant represents password reset request.
  bool get isPasswordReset {
    return this == passwordReset;
  }

  /// Resolves the localized description key for the given viewport [size].
  String descriptionKeyFor(ScreenSize size) {
    return size.select(
      mobile: mobileDescriptionKey ?? descriptionKey,
      tablet: tabletDescriptionKey ?? descriptionKey,
      desktop: descriptionKey,
    );
  }

  /// Whether this form should present a loading or disabled state for [state].
  bool isBusy(AuthRequestState state) {
    return state is AuthRequestLoading ||
        (state is AuthRequestSuccess && opensHomeOnSuccess);
  }
}
