import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/extensions/institution_record_name_ordering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sorts institution records by Turkish names without changing input', () {
    const clinics = [
      Clinic(id: 'one', name: 'Üroloji'),
      Clinic(id: 'two', name: 'Cildiye'),
      Clinic(id: 'three', name: 'İç Hastalıkları'),
      Clinic(id: 'four', name: 'Çocuk Sağlığı'),
    ];

    final sortedClinics = clinics.sortedByName();

    expect(sortedClinics.map((clinic) => clinic.name), [
      'Cildiye',
      'Çocuk Sağlığı',
      'İç Hastalıkları',
      'Üroloji',
    ]);
    expect(clinics.map((clinic) => clinic.name), [
      'Üroloji',
      'Cildiye',
      'İç Hastalıkları',
      'Çocuk Sağlığı',
    ]);
  });
}
