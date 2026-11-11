import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_catalog.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// The design's example data: one clinic, one branch, four departments,
/// four services, four staff and seven appointments of Elif Kaya.
final class PatientFixtures {
  const PatientFixtures();

  /// The signed-in patient.
  Patient get patient =>
      const Patient(id: 'elif', fullName: 'Elif Kaya', email: 'elif@test');

  /// Tuesday 20 October 2026, 09:00.
  DateTime get now => DateTime(2026, 10, 20, 9);

  Clinic get clinic => const Clinic(id: 'clinic', name: 'Klinik');

  Branch get branch => Branch(
    id: 'branch',
    clinicId: 'clinic',
    name: 'Merkez Şube',
    address: 'Adres',
    workingHours: branchHours,
  );

  /// Monday through Saturday 08:00–18:00; closed on Sunday.
  WorkingHours get branchHours => WorkingHours({
    for (final day in Weekday.values)
      if (day != Weekday.sunday) day: [range(8, 0, 600)],
  });

  /// Monday 19 October 2026, the Monday of [now]'s week.
  CalendarDate get weekStart => CalendarDate(year: 2026, month: 10, day: 19);

  /// Dr. Murat Şahin's week: Monday 09:00–10:00, Tuesday 08:00–10:00,
  /// Wednesday 09:00–09:40, Thursday 09:00–12:00 and 13:30–14:30.
  StaffAvailability get muratAvailability => StaffAvailability(
    staffId: 'murat',
    branchId: 'branch',
    weekly: [
      WeeklyWindow(weekday: Weekday.monday, range: range(9, 0, 60)),
      WeeklyWindow(weekday: Weekday.tuesday, range: range(8, 0, 120)),
      WeeklyWindow(weekday: Weekday.wednesday, range: range(9, 0, 40)),
      WeeklyWindow(weekday: Weekday.thursday, range: range(13, 30, 60)),
      WeeklyWindow(weekday: Weekday.thursday, range: range(9, 0, 180)),
    ],
  );

  /// The range of [minutes] starting at [hour]:[minute].
  TimeRange range(int hour, int minute, int minutes) {
    final start = ClockTime(hour: hour, minute: minute);
    return TimeRange(
      start: start,
      end: ClockTime.fromMinutes(start.minutesSinceMidnight + minutes),
    );
  }

  /// An occupied [slot] on [date].
  BookedSlot booked(String id, CalendarDate date, TimeRange slot) {
    return BookedSlot(appointmentId: id, date: date, range: slot);
  }

  List<Department> get departments => const [
    Department(id: 'cardio', name: 'Kardiyoloji', branchId: 'branch'),
    Department(id: 'internal', name: 'Dahiliye', branchId: 'branch'),
    Department(id: 'radiology', name: 'Radyoloji', branchId: 'branch'),
    Department(id: 'lab', name: 'Laboratuvar', branchId: 'branch'),
  ];

  List<MedicalService> get services => [
    Examination(
      id: 'cardio-exam',
      name: 'Kardiyoloji Muayenesi',
      departmentId: 'cardio',
      branchId: 'branch',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(120000),
    ),
    Examination(
      id: 'internal-exam',
      name: 'Dahiliye Muayenesi',
      departmentId: 'internal',
      branchId: 'branch',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(90000),
    ),
    RadiologyService(
      id: 'xray',
      name: 'Akciğer Grafisi',
      departmentId: 'radiology',
      branchId: 'branch',
      duration: ServiceDuration(15),
      fee: Money.minorUnits(60000),
      modality: RadiologyModality.xRay,
      preparationNote: 'Metal takı ve aksesuarları çıkarın.',
    ),
    LabTest(
      id: 'lipid',
      name: 'Lipid Paneli',
      departmentId: 'lab',
      branchId: 'branch',
      duration: ServiceDuration(10),
      fee: Money.minorUnits(40000),
      resultTime: LabResultTime.oneDay,
      fastingHours: FastingHours(min: 8, max: 12),
    ),
  ];

  List<Staff> get staff => const [
    Doctor(
      id: 'ayse',
      fullName: 'Dr. Ayşe Yılmaz',
      email: 'ayse@test',
      branchId: 'branch',
      departmentId: 'cardio',
      serviceIds: ['cardio-exam'],
      specialty: 'Kardiyoloji',
    ),
    Doctor(
      id: 'murat',
      fullName: 'Dr. Murat Şahin',
      email: 'murat@test',
      branchId: 'branch',
      departmentId: 'internal',
      serviceIds: ['internal-exam'],
      specialty: 'Dahiliye',
    ),
    Technician(
      id: 'can',
      fullName: 'Tekn. Can Aydın',
      email: 'can@test',
      branchId: 'branch',
      departmentId: 'radiology',
      serviceIds: ['xray'],
    ),
    Technician(
      id: 'zeynep',
      fullName: 'Tekn. Zeynep Arslan',
      email: 'zeynep@test',
      branchId: 'branch',
      departmentId: 'lab',
      serviceIds: ['lipid'],
    ),
  ];

  PatientCatalog get catalog => PatientCatalog(
    branches: [branch],
    departments: departments,
    services: services,
    staff: staff,
  );

  /// Monday 26 October, 10:40–11:00, approved.
  Appointment get cardiology => appointment(
    'a1',
    'cardio-exam',
    'ayse',
    AppointmentStatus.approved,
    DateTime(2026, 10, 26, 10, 40),
    20,
  );

  /// Wednesday 28 October, 08:30–08:40, pending.
  Appointment get lipid => appointment(
    'a2',
    'lipid',
    'zeynep',
    AppointmentStatus.pending,
    DateTime(2026, 10, 28, 8, 30),
    10,
  );

  /// Friday 30 October, 14:15–14:30, pending.
  Appointment get xray => appointment(
    'a3',
    'xray',
    'can',
    AppointmentStatus.pending,
    DateTime(2026, 10, 30, 14, 15),
    15,
  );

  /// 12 October, completed.
  Appointment get internal => appointment(
    'a4',
    'internal-exam',
    'murat',
    AppointmentStatus.completed,
    DateTime(2026, 10, 12, 9, 20),
    20,
  );

  /// 5 October, no-show.
  Appointment get noShow => appointment(
    'a5',
    'cardio-exam',
    'ayse',
    AppointmentStatus.noShow,
    DateTime(2026, 10, 5, 11),
    20,
  );

  /// 29 September, rejected.
  Appointment get rejected => appointment(
    'a6',
    'xray',
    'can',
    AppointmentStatus.rejected,
    DateTime(2026, 9, 29, 15),
    15,
    reason: 'Cihaz bakımda, başka bir gün seçin.',
  );

  /// 22 September, cancelled by the patient.
  Appointment get cancelled => appointment(
    'a7',
    'lipid',
    'zeynep',
    AppointmentStatus.cancelledByPatient,
    DateTime(2026, 9, 22, 8, 30),
    10,
  );

  /// Every appointment in stored (unsorted) order.
  List<Appointment> get appointments => [
    internal,
    cancelled,
    cardiology,
    rejected,
    xray,
    noShow,
    lipid,
  ];

  /// Restores an appointment of [patient] whose service, department and
  /// branch come from the catalog entry [serviceId].
  Appointment appointment(
    String id,
    String serviceId,
    String staffId,
    AppointmentStatus status,
    DateTime start,
    int minutes, {
    String? patientId,
    String? patientName,
    String? reason,
  }) {
    final service = services.firstWhere((item) => item.id == serviceId);
    final startTime = ClockTime(hour: start.hour, minute: start.minute);
    return Appointment.restore(
      id: id,
      patientId: patientId ?? patient.id,
      patientName: patientName ?? patient.fullName,
      staffId: staffId,
      branchId: service.branchId,
      departmentId: service.departmentId,
      serviceId: serviceId,
      serviceName: service.name,
      fee: service.fee,
      date: CalendarDate.fromDateTime(start),
      range: TimeRange(
        start: startTime,
        end: ClockTime.fromMinutes(startTime.minutesSinceMidnight + minutes),
      ),
      status: status,
      history: [
        AppointmentStatusChange(
          status: status,
          byUserId: patient.id,
          byRole: UserRole.patient,
          at: DateTime(2026, 9),
          reason: reason,
        ),
      ],
    );
  }
}
