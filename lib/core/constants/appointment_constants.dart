/// Shared appointment lifecycle policy values.
abstract final class AppointmentConstants {
  /// value = 15; minutes after the start before staff may mark a no-show.
  static const int noShowToleranceMinutes = 15;

  /// value = 500; maximum characters permitted in a status change reason.
  static const int statusReasonMaxLength = 500;
}
