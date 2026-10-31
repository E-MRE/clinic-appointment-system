import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_filter_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'selects and clears department while preserving role, and vice versa',
    () async {
      final cubit = StaffFilterCubit();
      addTearDown(cubit.close);
      expect(cubit.state, const StaffFilter());
      cubit.selectRole(StaffRoleFilter.doctor);
      cubit.selectDepartment('Kardiyoloji');
      expect(
        cubit.state,
        const StaffFilter(
          role: StaffRoleFilter.doctor,
          departmentName: 'Kardiyoloji',
        ),
      );
      cubit.selectRole(StaffRoleFilter.technician);
      expect(cubit.state.departmentName, 'Kardiyoloji');
      cubit.selectDepartment(null);
      expect(cubit.state, const StaffFilter(role: StaffRoleFilter.technician));
      cubit.selectRole(StaffRoleFilter.all);
      expect(cubit.state, const StaffFilter());
    },
  );
}
