import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('each profile reports its role', () {
    const patient = Patient(id: 'p1', fullName: 'Ada', email: 'ada@test.com');
    const admin = Admin(id: 'a1', fullName: 'Alan', email: 'alan@test.com');
    const doctor = Doctor(
      id: 'd1',
      fullName: 'Grace',
      email: 'grace@test.com',
      branchId: 'b1',
      departmentId: 'dep1',
      serviceIds: [],
      specialty: 'Cardiology',
    );
    const technician = Technician(
      id: 't1',
      fullName: 'Linus',
      email: 'linus@test.com',
      branchId: 'b1',
      departmentId: 'dep2',
      serviceIds: [],
    );

    expect(patient.role, UserRole.patient);
    expect(admin.role, UserRole.admin);
    expect(doctor.role, UserRole.doctor);
    expect(technician.role, UserRole.technician);
    expect(technician.departmentId, 'dep2');
  });
}
