/// Shared limits and numeric constraints for medical services.
abstract final class MedicalServiceConstants {
  /// Minimum duration in minutes for a medical service.
  static const int minDurationMinutes = 5;

  /// Maximum duration in minutes for a medical service.
  static const int maxDurationMinutes = 240;

  /// Number of minor units in one Turkish Lira.
  static const int minorUnitsPerLira = 100;

  /// Minimum fee in minor units (1 ₺).
  static const int minFeeMinorUnits = 100;

  /// Maximum fee in minor units (100,000 ₺).
  static const int maxFeeMinorUnits = 10000000;

  /// Maximum allowed decimal digits for lira input.
  static const int maxFeeDecimalDigits = 2;

  /// Minimum fasting duration in hours.
  static const int minFastingHours = 1;

  /// Maximum fasting duration in hours.
  static const int maxFastingHours = 24;

  /// Maximum allowed character count for a radiology preparation note.
  static const int maxPreparationNoteLength = 200;

  /// A duration input made of digits only.
  static final RegExp durationPattern = RegExp(r'^\d+$');

  /// Whole lira with an optional `,` or `.` decimal part of one or two digits.
  static final RegExp feePattern = RegExp(r'^(\d+)(?:[.,](\d{1,2}))?$');

  /// One number of fasting hours, or two joined by `-` or an en dash.
  static final RegExp fastingHoursPattern = RegExp(
    r'^(\d+)(?:\s*[-\u2013]\s*(\d+))?$',
  );
}
