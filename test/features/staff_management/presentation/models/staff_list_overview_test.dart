import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_list_overview.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();
  final doctor = fixtures.doctor(
    id: 'doctor',
    branchId: 'north',
    departmentId: 'cardio-north',
    serviceIds: ['lab', 'missing', 'exam'],
  );
  final secondDoctor = fixtures.doctor(
    id: 'second',
    branchId: 'south',
    departmentId: 'cardio-south',
  );
  final technician = fixtures.technician(
    id: 'technician',
    branchId: 'south',
    departmentId: 'lab-south',
  );
  final unknownDepartment = fixtures.doctor(
    id: 'unknown',
    branchId: 'north',
    departmentId: 'missing',
  );
  final outsider = fixtures.doctor(
    id: 'outside',
    branchId: 'other-clinic',
    departmentId: 'outside',
  );
  final branches = ['north', 'south', 'empty']
      .map(
        (id) => Branch(
          id: id,
          name: id.toUpperCase(),
          clinicId: 'clinic',
          address: '',
          workingHours: WorkingHours.closed(),
        ),
      )
      .toList();
  const departments = [
    Department(id: 'cardio-north', name: 'Kardiyoloji', branchId: 'north'),
    Department(id: 'cardio-south', name: 'Kardiyoloji', branchId: 'south'),
    Department(id: 'lab-south', name: 'Laboratuvar', branchId: 'south'),
    Department(id: 'unused', name: 'Unused', branchId: 'north'),
    Department(id: 'outside', name: 'Outside', branchId: 'other-clinic'),
  ];
  late StaffListOverview overview;

  setUp(() {
    overview = StaffListOverview(
      staff: [doctor, secondDoctor, technician, unknownDepartment, outsider],
      branches: branches,
      departments: departments,
      services: fixtures.services(),
    );
  });

  test('counts each role only in selected clinic branches', () {
    expect(overview.staff, [
      doctor,
      secondDoctor,
      technician,
      unknownDepartment,
    ]);
    expect(overview.count(StaffRoleFilter.all), overview.staff.length);
    expect(
      overview.count(StaffRoleFilter.doctor),
      [doctor, secondDoctor, unknownDepartment].length,
    );
    expect(
      overview.doctorCount,
      [doctor, secondDoctor, unknownDepartment].length,
    );
    expect(overview.count(StaffRoleFilter.technician), [technician].length);
    expect(overview.technicianCount, [technician].length);
    expect(overview.branchCount, branches.length);
  });

  test(
    'department names are distinct, sorted and limited to staffed departments',
    () {
      expect(overview.departmentNames, ['Kardiyoloji', 'Laboratuvar']);
    },
  );

  test('department-name filter spans branches and preserves staff order', () {
    expect(
      overview.filtered(const StaffFilter(departmentName: 'Kardiyoloji')),
      [doctor, secondDoctor],
    );
    expect(overview.filtered(const StaffFilter()), overview.staff);
  });

  test(
    'combines role and department with AND, including empty combinations',
    () {
      expect(
        overview.filtered(
          const StaffFilter(
            role: StaffRoleFilter.doctor,
            departmentName: 'Kardiyoloji',
          ),
        ),
        [doctor, secondDoctor],
      );
      expect(
        overview.filtered(
          const StaffFilter(
            role: StaffRoleFilter.technician,
            departmentName: 'Kardiyoloji',
          ),
        ),
        isEmpty,
      );
      expect(
        overview.filtered(const StaffFilter(role: StaffRoleFilter.technician)),
        [technician],
      );
    },
  );

  test('unknown department names never match unknown department ids', () {
    expect(
      overview.filtered(const StaffFilter(departmentName: 'missing')),
      isEmpty,
    );
    expect(overview.filtered(const StaffFilter(departmentName: '')), isEmpty);
  });

  test('resolves branch and department names with empty unknown fallback', () {
    expect(overview.branchName(doctor), 'NORTH');
    expect(overview.branchName(outsider), '');
    expect(overview.departmentName(doctor), 'Kardiyoloji');
    expect(overview.departmentName(unknownDepartment), '');
  });

  test('service names follow assignment order and skip unknown ids', () {
    expect(overview.serviceNames(doctor), ['Blood count', 'Consultation']);
    expect(overview.serviceNames(technician), isEmpty);
  });

  test('empty clinic has no staff, counts or department choices', () {
    final empty = StaffListOverview(
      staff: [doctor],
      branches: [],
      departments: departments,
      services: [],
    );
    expect(empty.staff, isEmpty);
    expect(empty.count(StaffRoleFilter.all), empty.staff.length);
    expect(empty.departmentNames, isEmpty);
    expect(empty.branchCount, empty.staff.length);
  });

  test('snapshots inputs and exposes unmodifiable staff results', () {
    final source = <Staff>[doctor];
    final snapshot = StaffListOverview(
      staff: source,
      branches: branches,
      departments: departments,
      services: [],
    );
    source.clear();
    expect(snapshot.staff, [doctor]);
    expect(() => snapshot.staff.clear(), throwsUnsupportedError);
    expect(
      () => snapshot.filtered(const StaffFilter()).clear(),
      throwsUnsupportedError,
    );
  });
}
