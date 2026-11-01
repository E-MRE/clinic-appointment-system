import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Real domain inputs shared by lifecycle tests.
final class AppointmentFixture {
  /// Creates the lifecycle test inputs.
  const AppointmentFixture();

  /// A request moment before the appointment.
  DateTime get requestedAt => DateTime(2026, 11, 1, 8);

  /// One minute before the local appointment start.
  DateTime get beforeStart => DateTime(2026, 11, 1, 9, 59);

  /// The exact local appointment start.
  DateTime get start => DateTime(2026, 11, 1, 10);

  /// Fourteen minutes after the start.
  DateTime get beforeTolerance => DateTime(2026, 11, 1, 10, 14);

  /// Fifteen minutes after the start.
  DateTime get atTolerance => DateTime(2026, 11, 1, 10, 15);

  /// The appointment calendar date.
  CalendarDate get date => CalendarDate.fromDateTime(start);

  /// A thirty-minute examination at ten o'clock.
  TimeRange get range => TimeRange(
    start: ClockTime(hour: 10, minute: 0),
    end: ClockTime(hour: 10, minute: 30),
  );

  /// The booked fee snapshot.
  Money get fee => Money.minorUnits(85000);

  /// The appointment's own patient actor.
  AppointmentActor get patient => actor(UserRole.patient, 'patient');

  /// Builds an actor from a real profile of the requested role and id.
  AppointmentActor actor(UserRole role, String id) {
    final User user = switch (role) {
      UserRole.patient => Patient(id: id, fullName: 'Patient', email: 'p@test'),
      UserRole.admin => Admin(id: id, fullName: 'Admin', email: 'a@test'),
      UserRole.doctor => Doctor(
        id: id,
        fullName: 'Doctor',
        email: 'd@test',
        branchId: 'branch',
        departmentId: 'department',
        serviceIds: const ['service'],
        specialty: 'Cardiology',
      ),
      UserRole.technician => Technician(
        id: id,
        fullName: 'Technician',
        email: 't@test',
        branchId: 'branch',
        departmentId: 'department',
        serviceIds: const ['service'],
      ),
    };
    return AppointmentActor.fromUser(user);
  }

  /// Requests the example appointment with an optional acting identity.
  Appointment request({AppointmentActor? by}) {
    return Appointment.request(
      patientId: 'patient',
      staffId: 'staff',
      branchId: 'branch',
      departmentId: 'department',
      serviceId: 'service',
      serviceName: 'Examination',
      fee: fee,
      date: date,
      range: range,
      by: by ?? patient,
      at: requestedAt,
    );
  }

  /// Creates an initial audit entry for a stored status.
  AppointmentStatusChange change(AppointmentStatus status) {
    return AppointmentStatusChange(
      status: status,
      byUserId: 'patient',
      byRole: UserRole.patient,
      at: requestedAt,
    );
  }

  /// Restores the example appointment with optional audit and id overrides.
  Appointment restore(
    AppointmentStatus status, {
    List<AppointmentStatusChange>? history,
    String id = 'appointment',
  }) {
    return Appointment.restore(
      id: id,
      patientId: 'patient',
      staffId: 'staff',
      branchId: 'branch',
      departmentId: 'department',
      serviceId: 'service',
      serviceName: 'Examination',
      fee: fee,
      date: date,
      range: range,
      status: status,
      history: history ?? [change(status)],
    );
  }

  /// Invokes a lifecycle method through the entity's public interface.
  Appointment transition(
    String method,
    Appointment appointment,
    AppointmentActor by,
    DateTime at,
  ) {
    return switch (method) {
      'approve' => appointment.approve(by: by, at: at),
      'reject' => appointment.reject(by: by, at: at),
      'cancelByPatient' => appointment.cancelByPatient(by: by, at: at),
      'cancelByStaff' => appointment.cancelByStaff(by: by, at: at),
      'complete' => appointment.complete(by: by, at: at),
      'markNoShow' => appointment.markNoShow(by: by, at: at),
      _ => throw ArgumentError.value(method),
    };
  }
}
