/// Time boundary; implementations must supply the current instant.
abstract interface class Clock {
  /// Implementations must return their current instant without changing its zone.
  DateTime now();
}
