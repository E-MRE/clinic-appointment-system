import 'package:clinic_appointment_system/core/extensions/turkish_case_folding.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('lowercases dotted and dotless I under Turkish rules', () {
    expect('IŞIK İLAÇ'.turkishLowercase, 'ışık ilaç');
  });

  test('contains ignores Turkish case', () {
    expect('Işıl İnce'.containsTurkishInsensitive('ışıl i'), isTrue);
    expect('Işıl İnce'.containsTurkishInsensitive('ISIL'), isFalse);
    expect('Ayşe'.containsTurkishInsensitive(''), isTrue);
  });
}
