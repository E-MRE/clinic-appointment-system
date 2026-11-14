/// Fixed values of the administrator appointment list.
abstract final class AdminAppointmentConstants {
  /// value = 10; table rows shown on one page.
  static const int rowsPerPage = 10;

  /// value = 1; appointment filter fields on narrow mobile screens.
  static const int mobileFilterColumns = 1;

  /// value = 2; appointment filter fields on tablet screens.
  static const int tabletFilterColumns = 2;

  /// value = 4; appointment filter fields on desktop screens.
  static const int desktopFilterColumns = 4;

  /// value = 1900; earliest year accepted by the appointment range picker.
  static const int firstSelectableYear = 1900;

  /// value = 2100; latest year accepted by the appointment range picker.
  static const int lastSelectableYear = 2100;
}
