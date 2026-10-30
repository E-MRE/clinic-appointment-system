import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts a monetary fee to and from its stored minor-unit integer.
final class MoneyConverter extends JsonConverter<Money, int> {
  /// Creates a converter for monetary amounts.
  const MoneyConverter();

  @override
  Money fromJson(int json) => Money.minorUnits(json);

  @override
  int toJson(Money object) => object.minorUnits;
}
