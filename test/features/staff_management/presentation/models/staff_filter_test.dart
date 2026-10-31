import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('copies filters by value and clears department explicitly', () {
    const original = StaffFilter(
      role: StaffRoleFilter.doctor,
      departmentName: 'Kardiyoloji',
    );
    expect(original.copyWith(), original);
    expect(
      original.copyWith(role: StaffRoleFilter.technician),
      const StaffFilter(
        role: StaffRoleFilter.technician,
        departmentName: 'Kardiyoloji',
      ),
    );
    expect(
      original.copyWith(departmentName: 'Laboratuvar'),
      const StaffFilter(
        role: StaffRoleFilter.doctor,
        departmentName: 'Laboratuvar',
      ),
    );
    expect(
      original.withoutDepartment(),
      const StaffFilter(role: StaffRoleFilter.doctor),
    );
    expect(original.withoutDepartment(), isNot(original));
  });
}
