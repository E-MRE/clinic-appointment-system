import 'package:clinic_appointment_system/features/appointments/domain/actors/staff_appointment_actor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';

/// Builds the lifecycle actor of a signed-in staff member without runtime
/// role checks.
final class StaffAppointmentActorVisitor
    implements StaffVisitor<StaffAppointmentActor> {
  /// Creates a stateless actor visitor.
  const StaffAppointmentActorVisitor();

  /// Acts as a doctor.
  @override
  StaffAppointmentActor visitDoctor(Doctor staff) {
    return StaffAppointmentActor.doctor(id: staff.id);
  }

  /// Acts as a technician.
  @override
  StaffAppointmentActor visitTechnician(Technician staff) {
    return StaffAppointmentActor.technician(id: staff.id);
  }
}
