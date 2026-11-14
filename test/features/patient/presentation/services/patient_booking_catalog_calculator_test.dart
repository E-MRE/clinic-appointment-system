import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_department_summary.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/patient_booking_catalog_calculator.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  const calculator = PatientBookingCatalogCalculator();

  test('departments count bookable services and stay name-sorted', () {
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
    final catalog = ClinicCatalog(
      clinics: [fixtures.clinic],
      branches: [fixtures.branch],
      departments: [
        ...fixtures.departments,
        const Department(id: 'empty', name: 'Acil', branchId: 'branch'),
      ],
      services: [...fixtures.services, unstaffed, secondCardio],
      staff: [...fixtures.staff, cardiologist],
    );
    final List<PatientDepartmentSummary> summaries = calculator.calculate(
      catalog,
    );
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
