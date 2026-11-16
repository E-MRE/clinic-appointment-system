/// Identifies the admin operation represented by a demo data request state.
enum DemoDataCommand {
  /// Writes a new deterministic demo scenario.
  load,

  /// Deletes records owned by the demo seed.
  clear,
}
