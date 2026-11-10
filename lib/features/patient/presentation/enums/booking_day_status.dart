/// Whether a listed booking day can be chosen.
enum BookingDayStatus {
  /// No upcoming slot exists: no window, a closed branch or only past slots.
  closed,

  /// Every upcoming slot is taken.
  full,

  /// At least one upcoming slot is free.
  available,
}
