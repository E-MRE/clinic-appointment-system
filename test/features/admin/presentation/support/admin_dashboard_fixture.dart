import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Real domain values shared by admin dashboard model and cubit tests.
final class AdminDashboardFixture {
  /// Creates a fixture for a fixed calendar day.
  const AdminDashboardFixture();

  /// The calendar day observed in dashboard tests.
  DateTime get day => DateTime(2026, 11, 14);

  /// The local calendar date observed in dashboard tests.
  CalendarDate get calendarDay => CalendarDate.fromDateTime(day);

  /// A catalog with two branches, departments and staff members.
  ClinicCatalog get catalog {
    return ClinicCatalog(
      clinics: const [Clinic(id: 'clinic', name: 'Clinic')],
      branches: [
        Branch(
          id: 'branch-a',
          name: 'North Branch',
          clinicId: 'clinic',
          address: 'Address A',
          workingHours: WorkingHours.closed(),
        ),
        Branch(
          id: 'branch-b',
          name: 'South Branch',
          clinicId: 'clinic',
          address: 'Address B',
          workingHours: WorkingHours.closed(),
        ),
      ],
      departments: const [
        Department(
          id: 'department-a',
          name: 'Cardiology',
          branchId: 'branch-a',
        ),
        Department(id: 'department-b', name: 'Neurology', branchId: 'branch-b'),
      ],
      services: const [],
      staff: const [
        Doctor(
          id: 'staff-z',
          fullName: 'Zeynep Aydın',
          email: 'zeynep@example.com',
          branchId: 'branch-a',
          departmentId: 'department-a',
          serviceIds: [],
          specialty: 'Cardiology',
        ),
        Technician(
          id: 'staff-a',
          fullName: 'Ali Demir',
          email: 'ali@example.com',
          branchId: 'branch-a',
          departmentId: 'department-a',
          serviceIds: [],
        ),
        Doctor(
          id: 'staff-b',
          fullName: 'Burak Kaya',
          email: 'burak@example.com',
          branchId: 'branch-b',
          departmentId: 'department-b',
          serviceIds: [],
          specialty: 'Neurology',
        ),
      ],
    );
  }

  /// Builds an appointment with deterministic audit history and time.
  Appointment appointment({
    required String id,
    required AppointmentStatus status,
    DateTime? date,
    int startMinutes = 600,
    String branchId = 'branch-a',
    String departmentId = 'department-a',
    String staffId = 'staff-z',
    DateTime? createdAt,
  }) {
    final appointmentDay = date ?? day;
    final requestedAt = createdAt ?? DateTime(2026, 11, 14, 8);
    final history = <AppointmentStatusChange>[
      _change(AppointmentStatus.pending, requestedAt),
    ];
    if (status != AppointmentStatus.pending) {
      history.add(_change(status, requestedAt.add(const Duration(minutes: 5))));
    }
    final start = ClockTime.fromMinutes(startMinutes);
    return Appointment.restore(
      id: id,
      patientId: 'patient-$id',
      patientName: 'Patient $id',
      staffId: staffId,
      branchId: branchId,
      departmentId: departmentId,
      serviceId: 'service',
      serviceName: 'Consultation',
      fee: Money.minorUnits(10000),
      date: CalendarDate.fromDateTime(appointmentDay),
      range: TimeRange(
        start: start,
        end: ClockTime.fromMinutes(startMinutes + 30),
      ),
      status: status,
      history: history,
    );
  }

  AppointmentStatusChange _change(AppointmentStatus status, DateTime at) {
    return AppointmentStatusChange(
      status: status,
      byUserId: 'patient',
      byRole: UserRole.patient,
      at: at,
    );
  }
}
