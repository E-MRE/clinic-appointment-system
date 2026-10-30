import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:equatable/equatable.dart';

/// Monetary amount in Turkish Lira (TRY), stored with minor-unit precision.
final class Money extends Equatable {
  /// Creates a money amount from minor units.
  /// Throws [InstitutionException] with [InstitutionErrorCode.invalidFee] if
  /// [minorUnits] is outside allowed service fee limits.
  factory Money.minorUnits(int minorUnits) {
    if (minorUnits < MedicalServiceConstants.minFeeMinorUnits ||
        minorUnits > MedicalServiceConstants.maxFeeMinorUnits) {
      throw const InstitutionException(InstitutionErrorCode.invalidFee);
    }
    return Money._(minorUnits);
  }

  /// Parses whole lira or lira with up to
  /// [MedicalServiceConstants.maxFeeDecimalDigits] decimals (`850`, `850,5`,
  /// `850.50`) using integer arithmetic only.
  /// Throws [InstitutionException] with [InstitutionErrorCode.invalidFee] on
  /// malformed or out-of-range input.
  factory Money.parseLira(String input) {
    final match = MedicalServiceConstants.feePattern.firstMatch(input.trim());
    final lira = int.tryParse(match?.group(1) ?? '');
    // Rejecting lira above the minor-unit limit keeps the multiplication below
    // from overflowing for very long inputs.
    if (match == null ||
        lira == null ||
        lira > MedicalServiceConstants.maxFeeMinorUnits) {
      throw const InstitutionException(InstitutionErrorCode.invalidFee);
    }
    final minorUnits = int.parse(
      (match.group(2) ?? '').padRight(
        MedicalServiceConstants.maxFeeDecimalDigits,
        '0',
      ),
    );
    return Money.minorUnits(
      lira * MedicalServiceConstants.minorUnitsPerLira + minorUnits,
    );
  }

  const Money._(this.minorUnits);

  /// Amount in minor units (1 ₺ = 100 minor units).
  final int minorUnits;

  /// Amount in Turkish Lira for display purposes.
  double get lira => minorUnits / MedicalServiceConstants.minorUnitsPerLira;

  @override
  List<Object> get props => [minorUnits];

  @override
  String toString() => '$minorUnits minor units';
}
