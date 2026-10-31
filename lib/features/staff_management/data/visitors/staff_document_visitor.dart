import 'package:clinic_appointment_system/features/users/data/models/doctor_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/technician_model.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

/// Serializes all stored fields for creation of a staff profile.
final class StaffDocumentVisitor implements StaffVisitor<Map<String, dynamic>> {
  /// Creates the staff document serializer.
  const StaffDocumentVisitor();

  /// Returns all stored doctor fields, excluding the document id.
  @override
  Map<String, dynamic> visitDoctor(Doctor staff) =>
      DoctorModel.fromEntity(staff).toJson();

  /// Returns all stored technician fields, excluding doctor-only details.
  @override
  Map<String, dynamic> visitTechnician(Technician staff) =>
      TechnicianModel.fromEntity(staff).toJson();
}
