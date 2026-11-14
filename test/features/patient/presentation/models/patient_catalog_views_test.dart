import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_catalog_views.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();

  test('staffFor requires the assigned service and the same branch', () {
    final otherBranch = Examination(
      id: 'cardio-exam-annex',
      name: 'Kardiyoloji Muayenesi',
      departmentId: 'cardio',
      branchId: 'annex',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(120000),
    );
    const movedDoctor = Doctor(
      id: 'moved',
      fullName: 'Dr. Ece Taş',
      email: 'ece@test',
      branchId: 'annex',
      departmentId: 'cardio',
      serviceIds: ['cardio-exam'],
      specialty: 'Kardiyoloji',
    );
    final catalog = ClinicCatalog(
      clinics: [fixtures.clinic],
      branches: [fixtures.branch],
      departments: fixtures.departments,
      services: [...fixtures.services, otherBranch],
      staff: [...fixtures.staff, movedDoctor],
    );
    final cardiology = catalog.serviceById('cardio-exam');
    if (cardiology == null) fail('Fixture service is missing.');
    expect(catalog.staffFor(cardiology).map((member) => member.id), ['ayse']);
    expect(catalog.staffFor(otherBranch), isEmpty);
  });
}
