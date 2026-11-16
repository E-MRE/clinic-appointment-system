import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_overview_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/services/staff_list_overview_factory.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/staff_fixtures.dart';

void main() {
  const fixtures = StaffFixtures();

  test('updates the derived overview through its injected factory', () async {
    final cubit = StaffListOverviewCubit(const StaffListOverviewFactory());
    addTearDown(cubit.close);
    final doctor = fixtures.doctor(
      id: 'doctor',
      branchId: 'branch',
      departmentId: 'department',
      serviceIds: ['exam'],
    );
    final branch = Branch(
      id: 'branch',
      clinicId: 'clinic',
      name: 'Merkez',
      address: '',
      workingHours: WorkingHours.closed(),
    );

    cubit.update(
      clinicId: 'clinic',
      staff: [doctor],
      branches: [branch],
      departments: const [
        Department(id: 'department', name: 'Kardiyoloji', branchId: 'branch'),
      ],
      services: fixtures.services(),
    );

    expect(cubit.state.staff, [doctor]);
    expect(cubit.state.branchCount, 1);
    expect(cubit.state.departmentName(doctor), 'Kardiyoloji');
    expect(cubit.state.serviceNames(doctor), ['Consultation']);

    cubit.update(
      clinicId: null,
      staff: [doctor],
      branches: [branch],
      departments: const [],
      services: const [],
    );

    expect(cubit.state.staff, isEmpty);
    expect(cubit.state.branchCount, 0);
  });
}
