import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts a domain clock time to and from its zero-padded Firestore form.
final class ClockTimeConverter extends JsonConverter<ClockTime, String> {
  /// Creates a converter for `HH:mm` clock times.
  const ClockTimeConverter();

  @override
  ClockTime fromJson(String json) {
    if (json.length != 5 || json[2] != ':') {
      throw const FormatException('Clock time must use HH:mm.');
    }

    final hasOnlyDigits = [0, 1, 3, 4].every((index) {
      final character = json.codeUnitAt(index);
      return character >= 48 && character <= 57;
    });
    final hour = int.tryParse(json.substring(0, 2));
    final minute = int.tryParse(json.substring(3, 5));
    if (!hasOnlyDigits ||
        hour == null ||
        minute == null ||
        hour > 23 ||
        minute > 59) {
      throw const FormatException('Clock time must use a valid HH:mm value.');
    }

    return ClockTime(hour: hour, minute: minute);
  }

  @override
  String toJson(ClockTime object) => object.toString();
}
