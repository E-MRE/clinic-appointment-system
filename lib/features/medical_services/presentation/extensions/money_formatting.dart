import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:flutter/widgets.dart';

/// Formatting and input presentation for [Money] service fees.
extension MoneyFormatting on Money {
  /// Minor units left over after whole lira.
  int get _remainderMinorUnits =>
      minorUnits % MedicalServiceConstants.minorUnitsPerLira;

  /// Whole lira part of the amount.
  int get _wholeLira => minorUnits ~/ MedicalServiceConstants.minorUnitsPerLira;

  /// Fraction digits to show: none for whole lira, otherwise two.
  int get _decimalDigits {
    if (_remainderMinorUnits == 0) return 0;
    return MedicalServiceConstants.maxFeeDecimalDigits;
  }

  /// Formats this money amount into currency text (e.g. `₺1.200` or `₺850,50`).
  String formatted([BuildContext? context]) {
    return AppFormatters.formatCurrency(
      lira,
      context: context,
      decimalDigits: _decimalDigits,
    );
  }

  /// Plain string representation used to prefill input forms (e.g. `850` or `850,50`).
  String get inputText {
    if (_remainderMinorUnits == 0) return '$_wholeLira';
    final fraction = '$_remainderMinorUnits'.padLeft(
      MedicalServiceConstants.maxFeeDecimalDigits,
      '0',
    );
    return '$_wholeLira,$fraction';
  }
}
