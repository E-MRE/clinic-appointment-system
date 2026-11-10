/// Fixed layout ratios and grid counts for the patient pages.
abstract final class PatientLayoutConstants {
  /// Flex share of the appointments column on desktop.
  /// value = 711
  static const int appointmentsPrimaryFlex = 711;

  /// Flex share of the notes and departments column on desktop.
  /// value = 376
  static const int appointmentsSecondaryFlex = 376;

  /// Flex share of the service and staff column on desktop.
  /// value = 303
  static const int bookingChoiceFlex = 303;

  /// Flex share of the date and time card on desktop.
  /// value = 424
  static const int bookingScheduleFlex = 424;

  /// Flex share of the summary card on desktop.
  /// value = 261
  static const int bookingSummaryFlex = 261;

  /// Number of slots in each booking grid row.
  /// value = 4
  static const int bookingSlotColumns = 4;
}
