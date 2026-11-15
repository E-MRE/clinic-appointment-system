import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/services/staff_list_overview_factory.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();
  const factory = StaffListOverviewFactory();
  final staff = [
    fixtures.doctor(id: 'inside', branchId: 'inside'),
    fixtures.doctor(id: 'outside', branchId: 'outside'),
  ];
  final branches = [
    Branch(
      id: 'inside',
      clinicId: 'clinic',
      name: 'Inside',
      address: '',
      workingHours: WorkingHours.closed(),
    ),
    Branch(
      id: 'outside',
      clinicId: 'other-clinic',
      name: 'Outside',
      address: '',
      workingHours: WorkingHours.closed(),
    ),
  ];
  const departments = [
    Department(id: 'department', name: 'Kardiyoloji', branchId: 'inside'),
  ];

  test('scopes branch and staff output to the selected clinic', () {
    final overview = factory.create(
      clinicId: 'clinic',
      staff: staff,
      branches: branches,
      departments: departments,
      services: fixtures.services(),
    );

    expect(overview.staff, [staff.first]);
    expect(overview.branchCount, 1);
    expect(overview.departmentNames, ['Kardiyoloji']);
  });

  test('returns an empty clinic overview when no clinic is selected', () {
    final overview = factory.create(
      clinicId: null,
      staff: staff,
      branches: branches,
      departments: departments,
      services: const [],
    );

    expect(overview.staff, isEmpty);
    expect(overview.branchCount, 0);
  });
}
