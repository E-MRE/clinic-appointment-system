import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';

/// Monetary amount in Turkish Lira (TRY), stored with kurus precision.
final class Money {
  /// Whole lira with an optional `,` or `.` decimal part of one or two digits.
  static final RegExp _liraPattern = RegExp(r'^(\d+)(?:[.,](\d{1,2}))?$');

  /// Creates a money amount from kurus.
  /// Throws [InstitutionException] with [InstitutionErrorCode.invalidFee] if
  /// [kurus] is outside allowed service fee limits.
  factory Money.kurus(int kurus) {
    if (kurus < MedicalServiceConstants.minFeeKurus ||
        kurus > MedicalServiceConstants.maxFeeKurus) {
      throw const InstitutionException(InstitutionErrorCode.invalidFee);
    }
    return Money._(kurus);
  }

  /// Parses whole lira or lira with up to
  /// [MedicalServiceConstants.maxFeeDecimalDigits] decimals (`850`, `850,5`,
  /// `850.50`) using integer arithmetic only.
  /// Throws [InstitutionException] with [InstitutionErrorCode.invalidFee] on
  /// malformed or out-of-range input.
  factory Money.parseLira(String input) {
    final match = _liraPattern.firstMatch(input.trim());
    final lira = int.tryParse(match?.group(1) ?? '');
    // Rejecting lira above the kuruş limit keeps the multiplication below
    // from overflowing for very long inputs.
    if (match == null ||
        lira == null ||
        lira > MedicalServiceConstants.maxFeeKurus) {
      throw const InstitutionException(InstitutionErrorCode.invalidFee);
    }
    final kurus = int.parse(
      (match.group(2) ?? '').padRight(
        MedicalServiceConstants.maxFeeDecimalDigits,
        '0',
      ),
    );
    return Money.kurus(lira * MedicalServiceConstants.kurusPerLira + kurus);
  }

  const Money._(this.kurus);

  /// Amount in kurus (1 ₺ = 100 kurus).
  final int kurus;

  /// Amount in Turkish Lira for display purposes.
  double get lira => kurus / MedicalServiceConstants.kurusPerLira;

  @override
  bool operator ==(Object other) => other is Money && other.kurus == kurus;

  @override
  int get hashCode => kurus.hashCode;

  @override
  String toString() => '$kurus kurus';
}
