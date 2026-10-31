/// Named route locations shared by navigation and authentication pages.
/// Registration and password reset sit under sign-in so back pops to it.
abstract final class AppRoutes {
  /// Entry location redirected to the signed-in user's home.
  static const String home = '/';

  /// Patient home location.
  static const String patientHome = '/patient';

  /// Shared doctor and technician home location.
  static const String staffHome = '/staff';

  /// Relative staff availability path.
  static const String staffAvailabilitySegment = 'availability';

  /// Weekly and dated availability location.
  static const String staffAvailability =
      '$staffHome/$staffAvailabilitySegment';

  /// Administrator home location.
  static const String adminHome = '/admin';

  /// Institution overview and its branch routes.
  static const String institution = '/admin/institution';
  static const String branchNewSegment = 'clinics/:clinicId/branches/new';
  static const String branchDetailSegment =
      'clinics/:clinicId/branches/:branchId';
  static const String branchEditSegment = 'edit';
  static const String branchNewPattern = '$institution/$branchNewSegment';
  static const String branchDetailPattern = '$institution/$branchDetailSegment';
  static const String branchEditPattern =
      '$branchDetailPattern/$branchEditSegment';

  static String branchNew(String clinicId) =>
      '$institution/clinics/$clinicId/branches/new';
  static String branchDetail(String clinicId, String branchId) =>
      '$institution/clinics/$clinicId/branches/$branchId';
  static String branchEdit(String clinicId, String branchId) =>
      '${branchDetail(clinicId, branchId)}/edit';

  /// Medical services routes under admin.
  static const String services = '/admin/services';
  static const String serviceNewSegment = 'new';
  static const String serviceEditSegment = ':serviceId/edit';
  static const String serviceNew = '$services/$serviceNewSegment';
  static String serviceEdit(String id) => '$services/$id/edit';

  /// Staff management destination inside the administrator shell.
  static const String adminStaff = '/admin/staff';

  /// Relative path of the mobile staff creation page.
  static const String adminStaffNewSegment = 'new';

  /// Relative path of the mobile staff editing page.
  static const String adminStaffEditSegment = ':staffId/edit';

  /// Full location of the mobile staff creation page.
  static const String adminStaffNew = '$adminStaff/$adminStaffNewSegment';

  /// Full location of the mobile editor for the profile identified by [id].
  static String adminStaffEdit(String id) => '$adminStaff/$id/edit';

  /// Debug component catalogue location.
  static const String componentPreview = '/debug/components';
  static const String signIn = '/sign-in';
  static const String signUpSegment = 'register';
  static const String passwordResetSegment = 'reset-password';
  static const String signUp = '$signIn/$signUpSegment';
  static const String passwordReset = '$signIn/$passwordResetSegment';
}
