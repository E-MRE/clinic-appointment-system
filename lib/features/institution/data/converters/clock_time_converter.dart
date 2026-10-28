import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts a domain clock time to and from its zero-padded Firestore form.
final class ClockTimeConverter extends JsonConverter<ClockTime, String> {
  /// Creates a converter for `HH:mm` clock times.
  const ClockTimeConverter();

  int get _clockTimeLength => 5;

  int get _hourSeparatorIndex => 2;

  int get _firstHourDigitIndex => 0;

  int get _secondHourDigitIndex => 1;

  int get _firstMinuteDigitIndex => 3;

  int get _secondMinuteDigitIndex => 4;

  int get _firstHourCharacterIndex => 0;

  int get _hourCharacterEndIndex => 2;

  int get _firstMinuteCharacterIndex => 3;

  int get _minuteCharacterEndIndex => 5;

  int get _zeroCodeUnit => '0'.codeUnitAt(_firstHourCharacterIndex);

  int get _nineCodeUnit => '9'.codeUnitAt(_firstHourCharacterIndex);

  int get _lastHour => 23;

  int get _lastMinute => 59;

  @override
  ClockTime fromJson(String json) {
    if (json.length != _clockTimeLength || json[_hourSeparatorIndex] != ':') {
      throw const FormatException('Clock time must use HH:mm.');
    }

    final digitIndexes = <int>[
      _firstHourDigitIndex,
      _secondHourDigitIndex,
      _firstMinuteDigitIndex,
      _secondMinuteDigitIndex,
    ];
    final hasOnlyDigits = digitIndexes.every((index) {
      final character = json.codeUnitAt(index);
      return character >= _zeroCodeUnit && character <= _nineCodeUnit;
    });
    final hour = int.tryParse(
      json.substring(_firstHourCharacterIndex, _hourCharacterEndIndex),
    );
    final minute = int.tryParse(
      json.substring(_firstMinuteCharacterIndex, _minuteCharacterEndIndex),
    );
    if (!hasOnlyDigits ||
        hour == null ||
        minute == null ||
        hour > _lastHour ||
        minute > _lastMinute) {
      throw const FormatException('Clock time must use a valid HH:mm value.');
    }

    return ClockTime(hour: hour, minute: minute);
  }

  @override
  String toJson(ClockTime object) => object.toString();
}
