import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

final class RecordingStaffVisitor implements StaffVisitor<String> {
  Staff? visited;

  @override
  String visitDoctor(Doctor staff) {
    visited = staff;
    return 'doctor';
  }

  @override
  String visitTechnician(Technician staff) {
    visited = staff;
    return 'technician';
  }
}
