import 'package:clinic_appointment_system/features/institution/data/models/clinic_model.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const clinic = Clinic(id: 'clinic-1', name: 'North Clinic');

  test('fromEntity writes exactly the clinic schema without its id', () {
    expect(ClinicModel.fromEntity(clinic).toJson(), {'name': 'North Clinic'});
  });

  test('fromJson rebuilds the clinic values using the document id', () {
    final restored = ClinicModel.fromJson({
      'id': 'clinic-1',
      'name': 'North Clinic',
    });

    expect(restored, isA<Clinic>());
    expect(restored.id, clinic.id);
    expect(restored.name, clinic.name);
  });
}
