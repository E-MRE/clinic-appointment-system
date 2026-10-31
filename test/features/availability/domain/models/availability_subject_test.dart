import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AvailabilitySubject', () {
    test('uses both staff and branch for value identity', () {
      const subject = AvailabilitySubject(staffId: 'staff', branchId: 'branch');
      expect(
        subject,
        const AvailabilitySubject(staffId: 'staff', branchId: 'branch'),
      );
      expect(
        subject.hashCode,
        const AvailabilitySubject(
          staffId: 'staff',
          branchId: 'branch',
        ).hashCode,
      );
      expect(subject.props, ['staff', 'branch']);
      expect(
        subject,
        isNot(const AvailabilitySubject(staffId: 'other', branchId: 'branch')),
      );
      expect(
        subject,
        isNot(const AvailabilitySubject(staffId: 'staff', branchId: 'other')),
      );
    });
    test('extracts subject identifiers from either staff role', () {
      const doctor = Doctor(
        id: 'doctor',
        fullName: 'Doctor',
        email: 'd@test.com',
        branchId: 'branch',
        departmentId: 'department',
        serviceIds: [],
        specialty: 'Cardiology',
      );
      const technician = Technician(
        id: 'technician',
        fullName: 'Technician',
        email: 't@test.com',
        branchId: 'other-branch',
        departmentId: 'department',
        serviceIds: [],
      );
      expect(
        AvailabilitySubject.ofStaff(doctor),
        const AvailabilitySubject(staffId: 'doctor', branchId: 'branch'),
      );
      expect(
        AvailabilitySubject.ofStaff(technician),
        const AvailabilitySubject(
          staffId: 'technician',
          branchId: 'other-branch',
        ),
      );
    });
  });
}
