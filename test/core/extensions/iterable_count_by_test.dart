import 'package:clinic_appointment_system/core/extensions/iterable_count_by.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('counts elements by a derived key', () {
    final counts = [
      'one',
      'two',
      'three',
      'four',
    ].countBy((String value) => value.length);

    expect(counts, {3: 2, 5: 1, 4: 1});
  });

  test('returns an empty unmodifiable map for an empty iterable', () {
    final counts = <String>[].countBy((String value) => value);

    expect(counts, isEmpty);
    expect(() => counts['value'] = 1, throwsUnsupportedError);
  });
}
