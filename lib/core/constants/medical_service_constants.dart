/// Shared limits and numeric constraints for medical services.
abstract final class MedicalServiceConstants {
  /// Minimum duration in minutes for a medical service.
  static const int minDurationMinutes = 5;

  /// Maximum duration in minutes for a medical service.
  static const int maxDurationMinutes = 240;

  /// Number of kurus in one Turkish Lira.
  static const int kurusPerLira = 100;

  /// Minimum fee in kurus (1 ₺).
  static const int minFeeKurus = 100;

  /// Maximum fee in kurus (100,000 ₺).
  static const int maxFeeKurus = 10000000;

  /// Maximum allowed decimal digits for lira input.
  static const int maxFeeDecimalDigits = 2;

  /// Minimum fasting duration in hours.
  static const int minFastingHours = 1;

  /// Maximum fasting duration in hours.
  static const int maxFastingHours = 24;

  /// Maximum allowed character count for a radiology preparation note.
  static const int maxPreparationNoteLength = 200;
}
