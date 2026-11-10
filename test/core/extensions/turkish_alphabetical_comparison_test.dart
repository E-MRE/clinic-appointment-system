import 'package:clinic_appointment_system/core/extensions/turkish_alphabetical_comparison.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('orders Turkish letters at their alphabet positions', () {
    expect('c'.compareTurkishAlphabetically('ç'), lessThan(0));
    expect('ç'.compareTurkishAlphabetically('d'), lessThan(0));
    expect('g'.compareTurkishAlphabetically('ğ'), lessThan(0));
    expect('ğ'.compareTurkishAlphabetically('h'), lessThan(0));
    expect('Iğdır'.compareTurkishAlphabetically('İç'), lessThan(0));
    expect('ılık'.compareTurkishAlphabetically('iç'), lessThan(0));
    expect('o'.compareTurkishAlphabetically('ö'), lessThan(0));
    expect('s'.compareTurkishAlphabetically('ş'), lessThan(0));
    expect('u'.compareTurkishAlphabetically('ü'), lessThan(0));
  });

  test('uses Turkish casing and deterministic case tie-breaks', () {
    expect('I'.compareTurkishAlphabetically('ı'), 'I'.compareTo('ı'));
    expect('İ'.compareTurkishAlphabetically('i'), 'İ'.compareTo('i'));
    expect('I'.compareTurkishAlphabetically('İ'), lessThan(0));
  });

  test('sorts a shorter prefix first', () {
    expect('Dahiliye'.compareTurkishAlphabetically('Dahiliyeler'), lessThan(0));
  });

  test('uses compareTo when names are equal under Turkish ordering', () {
    expect('iç'.compareTurkishAlphabetically('İç'), 'iç'.compareTo('İç'));
    expect('iç'.compareTurkishAlphabetically('iç'), 0);
  });

  test('sorts spaces and digits before letters', () {
    expect(
      'Göz Hastalıkları'.compareTurkishAlphabetically('Gözlem'),
      lessThan(0),
    );
    expect('3D Ultrason'.compareTurkishAlphabetically('Cildiye'), lessThan(0));
    expect('Test 2'.compareTurkishAlphabetically('Test A'), lessThan(0));
  });

  test('orders characters outside the Turkish alphabet deterministically', () {
    expect('z'.compareTurkishAlphabetically('q'), lessThan(0));
    expect('q'.compareTurkishAlphabetically('w'), lessThan(0));
  });
}
