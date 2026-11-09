import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_catalog.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();

  test('lookups return records by id and null when unknown', () {
    final catalog = fixtures.catalog;
    expect(catalog.branchById('branch')?.name, 'Merkez Şube');
    expect(catalog.departmentById('cardio')?.name, 'Kardiyoloji');
    expect(catalog.serviceById('lipid')?.name, 'Lipid Paneli');
    expect(catalog.staffById('can')?.fullName, 'Tekn. Can Aydın');
    expect(catalog.branchById('missing'), isNull);
    expect(catalog.serviceById('missing'), isNull);
    expect(catalog.staffById('missing'), isNull);
    expect(catalog.services.map((service) => service.name), [
      'Akciğer Grafisi',
      'Dahiliye Muayenesi',
      'Kardiyoloji Muayenesi',
      'Lipid Paneli',
    ]);
  });

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
    final catalog = PatientCatalog(
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

  test('departments list counts of bookable services, sorted by name', () {
    final unstaffed = Examination(
      id: 'cardio-echo',
      name: 'Ekokardiyografi',
      departmentId: 'cardio',
      branchId: 'branch',
      duration: ServiceDuration(30),
      fee: Money.minorUnits(150000),
    );
    final secondCardio = Examination(
      id: 'cardio-control',
      name: 'Kardiyoloji Kontrol',
      departmentId: 'cardio',
      branchId: 'branch',
      duration: ServiceDuration(10),
      fee: Money.minorUnits(50000),
    );
    const cardiologist = Doctor(
      id: 'ali',
      fullName: 'Dr. Ali Er',
      email: 'ali@test',
      branchId: 'branch',
      departmentId: 'cardio',
      serviceIds: ['cardio-control'],
      specialty: 'Kardiyoloji',
    );
    final catalog = PatientCatalog(
      branches: [fixtures.branch],
      departments: [
        ...fixtures.departments,
        const Department(id: 'empty', name: 'Acil', branchId: 'branch'),
      ],
      services: [...fixtures.services, unstaffed, secondCardio],
      staff: [...fixtures.staff, cardiologist],
    );
    final summaries = catalog.departmentsWithServiceCounts;
    expect(
      [
        for (final summary in summaries)
          (summary.department.name, summary.serviceCount),
      ],
      [
        ('Dahiliye', 1),
        ('Kardiyoloji', 2),
        ('Laboratuvar', 1),
        ('Radyoloji', 1),
      ],
    );
  });
}
