import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/data/converters/calendar_date_converter.dart';
import 'package:clinic_appointment_system/core/data/converters/time_range_converter.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts dated windows to and from Firestore maps.
final class OneOffWindowsConverter
    extends JsonConverter<List<OneOffWindow>, List<dynamic>> {
  /// Creates a converter for dated windows.
  const OneOffWindowsConverter();

  @override
  List<OneOffWindow> fromJson(List<dynamic> json) {
    final windows = <OneOffWindow>[];
    const dateConverter = CalendarDateConverter();
    const rangeConverter = TimeRangeConverter();
    const keys = {
      FirestoreConstants.date,
      FirestoreConstants.start,
      FirestoreConstants.end,
    };
    for (final item in json) {
      if (item is! Map ||
          item.length != keys.length ||
          !item.keys.toSet().containsAll(keys)) {
        throw const FormatException(
          'A dated window must contain date, start and end.',
        );
      }
      final date = item[FirestoreConstants.date];
      if (date is! String) {
        throw const FormatException('A date must be a string.');
      }
      try {
        windows.add(
          OneOffWindow(
            date: dateConverter.fromJson(date),
            range: rangeConverter.fromJson({
              FirestoreConstants.start: item[FirestoreConstants.start],
              FirestoreConstants.end: item[FirestoreConstants.end],
            }),
          ),
        );
      } on TimeException {
        throw const FormatException('A range must end after it starts.');
      }
    }
    return windows;
  }

  @override
  List<dynamic> toJson(List<OneOffWindow> object) {
    const dateConverter = CalendarDateConverter();
    const rangeConverter = TimeRangeConverter();
    return [
      for (final window in object)
        {
          FirestoreConstants.date: dateConverter.toJson(window.date),
          ...rangeConverter.toJson(window.range),
        },
    ];
  }
}
