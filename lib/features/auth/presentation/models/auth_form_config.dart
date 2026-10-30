import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/router/app_routes.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/models/auth_footer_config.dart';

/// Labels, dimensions and layout decisions of one authentication screen,
/// one named constructor per `AuthFormKind`.
final class AuthFormConfig {
  /// Sign-in screen for every role.
  const AuthFormConfig.signIn()
    : this._(
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
        footer: const AuthFooterConfig(
          promptKey: LocaleKeys.auth_noAccount,
          actionKey: LocaleKeys.auth_registerPatient,
          alternateRoute: AppRoutes.signUp,
        ),
      );

  /// Patient self-registration screen.
  const AuthFormConfig.signUp()
    : this._(
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
        footer: const AuthFooterConfig(
          promptKey: LocaleKeys.auth_hasAccount,
          actionKey: LocaleKeys.auth_signInTitle,
          alternateRoute: AppRoutes.signIn,
        ),
      );

  /// Password reset request screen.
  const AuthFormConfig.passwordReset()
    : this._(
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
        footer: const AuthFooterConfig(
          promptKey: LocaleKeys.auth_hasAccount,
          actionKey: LocaleKeys.auth_signInTitle,
          alternateRoute: AppRoutes.signIn,
        ),
      );

  const AuthFormConfig._({
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
}
