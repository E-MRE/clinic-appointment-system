import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Branch branch(String id, String name, String clinicId) {
    return Branch(
      id: id,
      clinicId: clinicId,
      name: name,
      address: 'Address',
      workingHours: WorkingHours.closed(),
    );
  }

  test('indexes every record by id and returns null for unknown ids', () {
    const clinic = Clinic(id: 'clinic', name: 'Clinic');
    final branchRecord = branch('branch', 'Central Branch', 'clinic');
    const department = Department(
      id: 'department',
      name: 'Cardiology',
      branchId: 'branch',
    );
    final service = Examination(
      id: 'service',
      name: 'Cardiology Exam',
      departmentId: 'department',
      branchId: 'branch',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(120000),
    );
    const staffMember = Doctor(
      id: 'doctor',
      fullName: 'Dr. Ayşe Yılmaz',
      email: 'doctor@test',
      branchId: 'branch',
      departmentId: 'department',
      serviceIds: ['service'],
      specialty: 'Cardiology',
    );
    final catalog = ClinicCatalog(
      clinics: const [clinic],
      branches: [branchRecord],
      departments: const [department],
      services: [service],
      staff: const [staffMember],
    );

    expect(catalog.clinicById('clinic'), clinic);
    expect(catalog.branchById('branch'), branchRecord);
    expect(catalog.departmentById('department'), department);
    expect(catalog.serviceById('service'), service);
    expect(catalog.staffById('doctor'), staffMember);
    expect(catalog.clinicById('missing'), isNull);
    expect(catalog.branchById('missing'), isNull);
    expect(catalog.departmentById('missing'), isNull);
    expect(catalog.serviceById('missing'), isNull);
    expect(catalog.staffById('missing'), isNull);
  });

  test('sorts directory lists and keeps caller lists unchanged', () {
    const clinics = [
      Clinic(id: 'clinic-z', name: 'Z Klinik'),
      Clinic(id: 'clinic-a', name: 'A Klinik'),
    ];
    final branches = [
      branch('branch-z', 'Z Şube', 'clinic-a'),
      branch('branch-a', 'A Şube', 'clinic-a'),
    ];
    const departmentNames = [
      'Çocuk Sağlığı',
      'Dahiliye',
      'Cildiye',
      'İç Hastalıkları',
      'Ortopedi',
      'Öz Bakım',
      'Üroloji',
      'Şeker Ölçümü',
    ];
    final departments = [
      for (final entry in departmentNames.asMap().entries)
        Department(
          id: 'department-${entry.key}',
          name: entry.value,
          branchId: 'branch-a',
        ),
    ];
    final services = List<Examination>.generate(departmentNames.length, (
      int index,
    ) {
      return Examination(
        id: 'service-$index',
        name: departmentNames[index],
        departmentId: 'department-$index',
        branchId: 'branch-a',
        duration: ServiceDuration(10),
        fee: Money.minorUnits(100),
      );
    });
    const staff = [
      Doctor(
        id: 'doctor-z',
        fullName: 'Zeynep Doctor',
        email: 'zeynep@test',
        branchId: 'branch-a',
        departmentId: 'department-0',
        serviceIds: ['service-0'],
        specialty: 'General practice',
      ),
      Doctor(
        id: 'doctor-a',
        fullName: 'Ayşe Doctor',
        email: 'ayse@test',
        branchId: 'branch-a',
        departmentId: 'department-1',
        serviceIds: ['service-1'],
        specialty: 'General practice',
      ),
    ];
    final catalog = ClinicCatalog(
      clinics: clinics,
      branches: branches,
      departments: departments,
      services: services,
      staff: staff,
    );

    expect(catalog.clinics.map((clinic) => clinic.name), [
      'A Klinik',
      'Z Klinik',
    ]);
    expect(catalog.branches.map((item) => item.name), ['A Şube', 'Z Şube']);
    expect(catalog.departments.map((item) => item.name), [
      'Cildiye',
      'Çocuk Sağlığı',
      'Dahiliye',
      'İç Hastalıkları',
      'Ortopedi',
      'Öz Bakım',
      'Şeker Ölçümü',
      'Üroloji',
    ]);
    expect(catalog.services.map((item) => item.name), [
      'Cildiye',
      'Çocuk Sağlığı',
      'Dahiliye',
      'İç Hastalıkları',
      'Ortopedi',
      'Öz Bakım',
      'Şeker Ölçümü',
      'Üroloji',
    ]);
    expect(catalog.staff.map((item) => item.fullName), [
      'Ayşe Doctor',
      'Zeynep Doctor',
    ]);
    expect(departments.map((item) => item.name), departmentNames);
    expect(services.map((item) => item.name), departmentNames);
    expect(
      () => catalog.branches.add(branch('extra', 'Extra', 'clinic-a')),
      throwsUnsupportedError,
    );
  });
}
