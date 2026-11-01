import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

import 'appointment_fixture.dart';

/// Inputs for booking rule tests.
final class BookingFixture {
  /// Creates reusable inputs.
  const BookingFixture();

  /// Lifecycle examples.
  AppointmentFixture get lifecycle => const AppointmentFixture();

  /// Example date.
  CalendarDate get date => lifecycle.date;

  /// Builds a half-open range from clock times.
  TimeRange range(String start, String end) =>
      TimeRange(start: _clock(start), end: _clock(end));

  ClockTime _clock(String value) {
    final parts = value.split(':');
    return ClockTime.fromMinutes(
      int.parse(parts[0]) * 60 + int.parse(parts[1]),
    );
  }

  /// Builds a local date and time.
  DateTime at(String date, String time) {
    final day = DateTime.parse(date);
    final parts = time.split(':');
    return DateTime(
      day.year,
      day.month,
      day.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }

  /// Builds a stored appointment with selected values.
  Appointment appointment({
    String id = '',
    String staffId = 'staff',
    String patientId = 'patient',
    String serviceId = 'service',
    CalendarDate? date,
    TimeRange? range,
    AppointmentStatus status = AppointmentStatus.pending,
  }) => Appointment.restore(
    id: id,
    patientId: patientId,
    staffId: staffId,
    branchId: 'branch',
    departmentId: 'department',
    serviceId: serviceId,
    serviceName: 'Examination',
    fee: lifecycle.fee,
    date: date ?? this.date,
    range: range ?? this.range('10:00', '10:30'),
    status: status,
    history: [lifecycle.change(status)],
  );

  /// A compatible doctor.
  Staff doctor({
    String id = 'staff',
    String departmentId = 'department',
    List<String> serviceIds = const ['service'],
  }) => Doctor(
    id: id,
    fullName: 'Doctor',
    email: 'd@test',
    branchId: 'branch',
    departmentId: departmentId,
    serviceIds: serviceIds,
    specialty: 'Cardiology',
  );

  /// An examination.
  MedicalService service({
    String id = 'service',
    String departmentId = 'department',
  }) => Examination(
    id: id,
    name: 'Examination',
    departmentId: departmentId,
    branchId: 'branch',
    duration: ServiceDuration(30),
    fee: lifecycle.fee,
  );

  /// Branch hours with a lunch break.
  WorkingHours get hours => WorkingHours({
    date.weekday: [range('08:30', '12:00'), range('13:00', '18:00')],
  });

  /// Weekly and dated availability.
  StaffAvailability availability({
    List<WeeklyWindow>? weekly,
    List<OneOffWindow> oneOff = const [],
  }) => StaffAvailability(
    staffId: 'staff',
    branchId: 'branch',
    weekly:
        weekly ??
        [WeeklyWindow(weekday: date.weekday, range: range('09:00', '12:00'))],
    oneOff: oneOff,
  );

  /// A context with optional overrides.
  AppointmentBookingContext context({
    Staff? staff,
    MedicalService? service,
    StaffAvailability? availability,
    WorkingHours? hours,
    List<Appointment> staffAppointments = const [],
    List<Appointment> patientAppointments = const [],
    DateTime? now,
  }) => AppointmentBookingContext(
    staff: staff ?? doctor(),
    service: service ?? this.service(),
    availability: availability ?? this.availability(),
    branchHours: hours ?? this.hours,
    staffAppointments: staffAppointments,
    patientAppointments: patientAppointments,
    now: now ?? lifecycle.requestedAt,
  );
}
