import 'package:clinic_appointment_system/features/staff_management/presentation/extensions/user_role_staff_form_strategy.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/strategies/doctor_form_strategy.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/strategies/technician_form_strategy.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const values = StaffFormValues(
    fullName: '  Name  ',
    email: '  name@example.com  ',
    specialty: '  Cardiology  ',
    branchId: '  branch  ',
    departmentId: '  department  ',
    serviceIds: ['  exam  ', ' lab '],
  );

  test('resolves staff strategies and rejects non-staff roles', () {
    expect(UserRole.doctor.staffFormStrategy, isA<DoctorFormStrategy>());
    expect(
      UserRole.technician.staffFormStrategy,
      isA<TechnicianFormStrategy>(),
    );
    expect(() => UserRole.patient.staffFormStrategy, throwsUnsupportedError);
    expect(() => UserRole.admin.staffFormStrategy, throwsUnsupportedError);
  });

  test(
    'doctor strategy builds the right subclass and trims every profile field',
    () {
      final staff = const DoctorFormStrategy().build(values, id: 'original-id');
      expect(staff, isA<Doctor>());
      expect(staff.id, 'original-id');
      expect(
        StaffFormValues.fromStaff(staff),
        const StaffFormValues(
          role: UserRole.doctor,
          fullName: 'Name',
          email: 'name@example.com',
          specialty: 'Cardiology',
          branchId: 'branch',
          departmentId: 'department',
          serviceIds: ['exam', 'lab'],
        ),
      );
    },
  );

  test('technician strategy trims shared fields and ignores specialty', () {
    final staff = const TechnicianFormStrategy().build(
      values,
      id: 'technician-id',
    );
    expect(staff, isA<Technician>());
    expect(staff.id, 'technician-id');
    expect(
      StaffFormValues.fromStaff(staff),
      const StaffFormValues(
        role: UserRole.technician,
        fullName: 'Name',
        email: 'name@example.com',
        branchId: 'branch',
        departmentId: 'department',
        serviceIds: ['exam', 'lab'],
      ),
    );
  });
}
