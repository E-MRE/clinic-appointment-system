import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/staff_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action_transition.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_data_set.dart';
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
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';

/// Builds a complete, deterministic demo data set from a date and linked accounts.
final class DemoScenarioBuilder {
  /// Captures the clock and existing account identities used by this scenario.
  const DemoScenarioBuilder({required this.clock, required this.accounts});

  /// Supplies today's date for relative appointment generation.
  final Clock clock;

  /// Supplies the existing doctor and patient profile identities.
  final DemoAccounts accounts;

  int get _firstOrdinal => 1;
  int get _secondOrdinal => _firstOrdinal + 1;
  int get _thirdOrdinal => _firstOrdinal + 2;
  int get _fourthOrdinal => _firstOrdinal + 3;
  int get _fifthOrdinal => _firstOrdinal + 4;
  int get _sixthOrdinal => _firstOrdinal + 5;
  int get _seventhOrdinal => _firstOrdinal + 6;
  int get _eighthOrdinal => _firstOrdinal + 7;
  int get _linkedProfileIndex => 0;
  int get _firstListIndex => 0;
  int get _secondListIndex => 1;
  int get _thirdListIndex => 2;
  int get _fourthListIndex => 3;
  int get _todayAppointmentCount => 6;
  int get _previousDayCount => 6;
  int get _nextDayCount => 6;
  int get _extraAppointmentsOnEarlyFutureDays => 2;
  int get _appointmentsOnEarlyFutureDay => 2;
  int get _appointmentsOnOtherFutureDays => 1;
  int get _minutesPerHour => 60;
  int get _minuteAtHourBoundary => 0;
  int get _openingHour => 8;
  int get _closingHour => 18;
  int get _firstAppointmentHour => 9;
  int get _appointmentStartIntervalMinutes => 45;
  int get _appointmentRequestLeadMinutes => 120;
  int get _appointmentApprovalLeadMinutes => 60;
  int get _statusChangeLeadMinutes => 30;
  int get _noShowToleranceMinutes => 15;
  int get _standardFastingHours => 8;
  int get _extendedFastingHours => 12;
  int get _firstFeeMinorUnits => 85000;
  int get _secondFeeMinorUnits => 70000;
  int get _thirdFeeMinorUnits => 65000;
  int get _fourthFeeMinorUnits => 35000;
  int get _fifthFeeMinorUnits => 42000;
  int get _sixthFeeMinorUnits => 90000;
  int get _seventhFeeMinorUnits => 55000;
  int get _standardServiceDurationMinutes => 30;

  /// Produces all institutions, services, profiles, availability and appointments.
  DemoDataSet build() {
    _ensureLinkedAccountProfilesAreValid();
    final referenceDate = clock.today;
    final clinic = _buildClinic();
    final branches = _buildBranches(clinic);
    final departments = _buildDepartments(branches);
    final services = _buildServices(branches, departments);
    final staff = _buildStaff(branches, departments, services);
    final patients = _buildPatients();
    final availabilities = _buildAvailabilities(staff);
    final appointments = _buildAppointments(
      referenceDate: referenceDate,
      staff: staff,
      patients: patients,
      services: services,
    );

    return DemoDataSet(
      referenceDate: referenceDate,
      clinic: clinic,
      branches: branches,
      departments: departments,
      services: services,
      staff: staff,
      patients: patients,
      availabilities: availabilities,
      appointments: appointments,
    );
  }

  void _ensureLinkedAccountProfilesAreValid() {
    if (accounts.doctorUid.trim().isEmpty) {
      throw ArgumentError.value(accounts.doctorUid, 'doctorUid');
    }
    if (accounts.doctorFullName.trim().isEmpty) {
      throw ArgumentError.value(accounts.doctorFullName, 'doctorFullName');
    }
    if (accounts.doctorEmail.trim().isEmpty) {
      throw ArgumentError.value(accounts.doctorEmail, 'doctorEmail');
    }
    if (accounts.patientUid.trim().isEmpty) {
      throw ArgumentError.value(accounts.patientUid, 'patientUid');
    }
    if (accounts.patientFullName.trim().isEmpty) {
      throw ArgumentError.value(accounts.patientFullName, 'patientFullName');
    }
    if (accounts.patientEmail.trim().isEmpty) {
      throw ArgumentError.value(accounts.patientEmail, 'patientEmail');
    }
  }

  Clinic _buildClinic() {
    return Clinic(id: _demoId('clinic', _firstOrdinal), name: 'Mavi Klinik');
  }

  List<Branch> _buildBranches(Clinic clinic) {
    final workingHours = _buildWorkingHours();
    return [
      Branch(
        id: _demoId('branch', _firstOrdinal),
        name: 'Merkez Şube',
        clinicId: clinic.id,
        address: 'Atatürk Caddesi 18, İstanbul',
        workingHours: workingHours,
      ),
      Branch(
        id: _demoId('branch', _secondOrdinal),
        name: 'Sahil Şube',
        clinicId: clinic.id,
        address: 'Sahil Yolu 42, İstanbul',
        workingHours: workingHours,
      ),
    ];
  }

  WorkingHours _buildWorkingHours() {
    final opening = ClockTime(
      hour: _openingHour,
      minute: _minuteAtHourBoundary,
    );
    final closing = ClockTime(
      hour: _closingHour,
      minute: _minuteAtHourBoundary,
    );
    final hours = TimeRange(start: opening, end: closing);
    final ranges = <Weekday, List<TimeRange>>{};
    for (final weekday in Weekday.values) {
      ranges[weekday] = [hours];
    }
    return WorkingHours(ranges);
  }

  List<Department> _buildDepartments(List<Branch> branches) {
    return [
      Department(
        id: _demoId('department', _firstOrdinal),
        name: 'Kardiyoloji',
        branchId: branches[_firstListIndex].id,
      ),
      Department(
        id: _demoId('department', _secondOrdinal),
        name: 'Dahiliye',
        branchId: branches[_firstListIndex].id,
      ),
      Department(
        id: _demoId('department', _thirdOrdinal),
        name: 'Dermatoloji',
        branchId: branches[_secondListIndex].id,
      ),
      Department(
        id: _demoId('department', _fourthOrdinal),
        name: 'Görüntüleme ve Laboratuvar',
        branchId: branches[_secondListIndex].id,
      ),
    ];
  }

  List<MedicalService> _buildServices(
    List<Branch> branches,
    List<Department> departments,
  ) {
    final duration = ServiceDuration(_standardServiceDurationMinutes);
    return [
      Examination(
        id: _demoId('service', _firstOrdinal),
        name: 'Kardiyoloji Muayenesi',
        departmentId: departments[_firstListIndex].id,
        branchId: branches[_firstListIndex].id,
        duration: duration,
        fee: Money.minorUnits(_firstFeeMinorUnits),
      ),
      Examination(
        id: _demoId('service', _secondOrdinal),
        name: 'Dahiliye Muayenesi',
        departmentId: departments[_secondListIndex].id,
        branchId: branches[_firstListIndex].id,
        duration: duration,
        fee: Money.minorUnits(_secondFeeMinorUnits),
      ),
      Examination(
        id: _demoId('service', _thirdOrdinal),
        name: 'Dermatoloji Muayenesi',
        departmentId: departments[_thirdListIndex].id,
        branchId: branches[_secondListIndex].id,
        duration: duration,
        fee: Money.minorUnits(_thirdFeeMinorUnits),
      ),
      LabTest(
        id: _demoId('service', _fourthOrdinal),
        name: 'Tam Kan Sayımı',
        departmentId: departments[_secondListIndex].id,
        branchId: branches[_firstListIndex].id,
        duration: duration,
        fee: Money.minorUnits(_fourthFeeMinorUnits),
        resultTime: LabResultTime.oneDay,
        fastingHours: FastingHours(
          min: _standardFastingHours,
          max: _standardFastingHours,
        ),
      ),
      LabTest(
        id: _demoId('service', _fifthOrdinal),
        name: 'Biyokimya Paneli',
        departmentId: departments[_fourthListIndex].id,
        branchId: branches[_secondListIndex].id,
        duration: duration,
        fee: Money.minorUnits(_fifthFeeMinorUnits),
        resultTime: LabResultTime.sameDay,
        fastingHours: FastingHours(
          min: _standardFastingHours,
          max: _extendedFastingHours,
        ),
      ),
      RadiologyService(
        id: _demoId('service', _sixthOrdinal),
        name: 'Akciğer Röntgeni',
        departmentId: departments[_fourthListIndex].id,
        branchId: branches[_secondListIndex].id,
        duration: duration,
        fee: Money.minorUnits(_sixthFeeMinorUnits),
        modality: RadiologyModality.xRay,
      ),
      RadiologyService(
        id: _demoId('service', _seventhOrdinal),
        name: 'Karın Ultrasonu',
        departmentId: departments[_fourthListIndex].id,
        branchId: branches[_secondListIndex].id,
        duration: duration,
        fee: Money.minorUnits(_seventhFeeMinorUnits),
        modality: RadiologyModality.ultrasound,
      ),
    ];
  }

  List<Staff> _buildStaff(
    List<Branch> branches,
    List<Department> departments,
    List<MedicalService> services,
  ) {
    final cardiologyServiceId = _serviceNamed(
      services,
      'Kardiyoloji Muayenesi',
    ).id;
    final internalMedicineServiceId = _serviceNamed(
      services,
      'Dahiliye Muayenesi',
    ).id;
    final dermatologyServiceId = _serviceNamed(
      services,
      'Dermatoloji Muayenesi',
    ).id;
    final bloodCountServiceId = _serviceNamed(services, 'Tam Kan Sayımı').id;
    final chemistryServiceId = _serviceNamed(services, 'Biyokimya Paneli').id;
    final xRayServiceId = _serviceNamed(services, 'Akciğer Röntgeni').id;
    final ultrasoundServiceId = _serviceNamed(services, 'Karın Ultrasonu').id;

    return [
      Doctor(
        id: accounts.doctorUid,
        fullName: accounts.doctorFullName.trim(),
        email: accounts.doctorEmail.trim(),
        branchId: branches[_firstListIndex].id,
        departmentId: departments[_firstListIndex].id,
        serviceIds: [cardiologyServiceId],
        specialty: 'Kardiyoloji',
      ),
      Doctor(
        id: _demoId('staff', _secondOrdinal),
        fullName: 'Dr. Ece Demir',
        email: 'ece.demir@example.test',
        branchId: branches[_firstListIndex].id,
        departmentId: departments[_secondListIndex].id,
        serviceIds: [internalMedicineServiceId],
        specialty: 'İç Hastalıkları',
      ),
      Doctor(
        id: _demoId('staff', _thirdOrdinal),
        fullName: 'Dr. Can Yılmaz',
        email: 'can.yilmaz@example.test',
        branchId: branches[_secondListIndex].id,
        departmentId: departments[_thirdListIndex].id,
        serviceIds: [dermatologyServiceId],
        specialty: 'Dermatoloji',
      ),
      Doctor(
        id: _demoId('staff', _fourthOrdinal),
        fullName: 'Dr. Selin Kaya',
        email: 'selin.kaya@example.test',
        branchId: branches[_firstListIndex].id,
        departmentId: departments[_firstListIndex].id,
        serviceIds: [cardiologyServiceId],
        specialty: 'Kardiyoloji',
      ),
      Technician(
        id: _demoId('staff', _fifthOrdinal),
        fullName: 'Teknisyen Arda Şen',
        email: 'arda.sen@example.test',
        branchId: branches[_secondListIndex].id,
        departmentId: departments[_fourthListIndex].id,
        serviceIds: [chemistryServiceId, xRayServiceId, ultrasoundServiceId],
      ),
      Technician(
        id: _demoId('staff', _sixthOrdinal),
        fullName: 'Teknisyen Derya Akın',
        email: 'derya.akin@example.test',
        branchId: branches[_firstListIndex].id,
        departmentId: departments[_secondListIndex].id,
        serviceIds: [bloodCountServiceId],
      ),
    ];
  }

  List<Patient> _buildPatients() {
    return [
      Patient(
        id: accounts.patientUid,
        fullName: accounts.patientFullName.trim(),
        email: accounts.patientEmail.trim(),
      ),
      Patient(
        id: _demoId('patient', _secondOrdinal),
        fullName: 'Elif Arslan',
        email: 'elif.arslan@example.test',
      ),
      Patient(
        id: _demoId('patient', _thirdOrdinal),
        fullName: 'Mert Aydın',
        email: 'mert.aydin@example.test',
      ),
      Patient(
        id: _demoId('patient', _fourthOrdinal),
        fullName: 'Zeynep Koç',
        email: 'zeynep.koc@example.test',
      ),
      Patient(
        id: _demoId('patient', _fifthOrdinal),
        fullName: 'Deniz Çelik',
        email: 'deniz.celik@example.test',
      ),
      Patient(
        id: _demoId('patient', _sixthOrdinal),
        fullName: 'Bora Şahin',
        email: 'bora.sahin@example.test',
      ),
      Patient(
        id: _demoId('patient', _seventhOrdinal),
        fullName: 'Aslı Yıldız',
        email: 'asli.yildiz@example.test',
      ),
      Patient(
        id: _demoId('patient', _eighthOrdinal),
        fullName: 'Ozan Kurt',
        email: 'ozan.kurt@example.test',
      ),
    ];
  }

  List<StaffAvailability> _buildAvailabilities(List<Staff> staff) {
    final range = TimeRange(
      start: ClockTime(hour: _openingHour, minute: _minuteAtHourBoundary),
      end: ClockTime(hour: _closingHour, minute: _minuteAtHourBoundary),
    );
    return staff.map((Staff member) {
      final weekly = Weekday.values.map(
        (Weekday weekday) => WeeklyWindow(weekday: weekday, range: range),
      );
      return StaffAvailability(
        staffId: member.id,
        branchId: member.branchId,
        weekly: weekly,
      );
    }).toList();
  }

  List<Appointment> _buildAppointments({
    required CalendarDate referenceDate,
    required List<Staff> staff,
    required List<Patient> patients,
    required List<MedicalService> services,
  }) {
    const todayStatuses = [
      AppointmentStatus.completed,
      AppointmentStatus.completed,
      AppointmentStatus.approved,
      AppointmentStatus.approved,
      AppointmentStatus.noShow,
      AppointmentStatus.pending,
    ];
    const previousStatuses = [
      AppointmentStatus.completed,
      AppointmentStatus.cancelledByStaff,
      AppointmentStatus.rejected,
      AppointmentStatus.completed,
      AppointmentStatus.cancelledByStaff,
      AppointmentStatus.rejected,
    ];
    const nextStatuses = [
      AppointmentStatus.pending,
      AppointmentStatus.approved,
      AppointmentStatus.pending,
      AppointmentStatus.approved,
      AppointmentStatus.pending,
      AppointmentStatus.approved,
      AppointmentStatus.pending,
      AppointmentStatus.approved,
    ];

    final appointments = <Appointment>[];
    for (int index = 0; index < _todayAppointmentCount; index++) {
      appointments.add(
        _buildAppointment(
          id: _demoId('appointment', appointments.length + _firstOrdinal),
          status: todayStatuses[index],
          date: referenceDate,
          staff: staff[index],
          patient: patients[appointments.length % patients.length],
          services: services,
          slotIndex: index,
        ),
      );
    }

    for (int dayOffset = 1; dayOffset <= _previousDayCount; dayOffset++) {
      appointments.add(
        _buildAppointment(
          id: _demoId('appointment', appointments.length + _firstOrdinal),
          status: previousStatuses[dayOffset - _firstOrdinal],
          date: _dateOffset(referenceDate, -dayOffset),
          staff: staff[(dayOffset - _firstOrdinal) % staff.length],
          patient: patients[appointments.length % patients.length],
          services: services,
          slotIndex: _linkedProfileIndex,
        ),
      );
    }

    for (int dayOffset = 1; dayOffset <= _nextDayCount; dayOffset++) {
      int appointmentsForDay = _appointmentsOnOtherFutureDays;
      if (dayOffset <= _extraAppointmentsOnEarlyFutureDays) {
        appointmentsForDay = _appointmentsOnEarlyFutureDay;
      }
      for (int slotIndex = 0; slotIndex < appointmentsForDay; slotIndex++) {
        appointments.add(
          _buildAppointment(
            id: _demoId('appointment', appointments.length + _firstOrdinal),
            status:
                nextStatuses[appointments.length -
                    _todayAppointmentCount -
                    _previousDayCount],
            date: _dateOffset(referenceDate, dayOffset),
            staff: staff[slotIndex],
            patient: patients[appointments.length % patients.length],
            services: services,
            slotIndex: slotIndex,
          ),
        );
      }
    }
    return appointments;
  }

  Appointment _buildAppointment({
    required String id,
    required AppointmentStatus status,
    required CalendarDate date,
    required Staff staff,
    required Patient patient,
    required List<MedicalService> services,
    required int slotIndex,
  }) {
    final service = services.singleWhere(
      (MedicalService candidate) => candidate.id == staff.serviceIds.first,
    );
    final startMinute =
        _firstAppointmentHour * _minutesPerHour +
        slotIndex * _appointmentStartIntervalMinutes;
    final start = ClockTime.fromMinutes(startMinute);
    final end = ClockTime.fromMinutes(startMinute + service.duration.minutes);
    final range = TimeRange(start: start, end: end);
    final startsAt = _dateTimeAt(date, startMinute);
    final requested = Appointment.request(
      id: id,
      patientId: patient.id,
      patientName: patient.fullName,
      staffId: staff.id,
      branchId: staff.branchId,
      departmentId: staff.departmentId,
      serviceId: service.id,
      serviceName: service.name,
      fee: service.fee,
      date: date,
      range: range,
      by: PatientAppointmentActor(id: patient.id),
      at: startsAt.subtract(Duration(minutes: _appointmentRequestLeadMinutes)),
    );

    if (status == AppointmentStatus.pending) {
      return requested;
    }
    if (status == AppointmentStatus.rejected) {
      return _apply(
        AppointmentAction.reject,
        requested,
        by: _staffActor(staff),
        at: startsAt.subtract(Duration(minutes: _statusChangeLeadMinutes)),
        reason: 'Bu hizmet için farklı bir uzman seçilmelidir.',
      );
    }

    final approved = _apply(
      AppointmentAction.approve,
      requested,
      by: _staffActor(staff),
      at: startsAt.subtract(Duration(minutes: _appointmentApprovalLeadMinutes)),
    );
    if (status == AppointmentStatus.approved) {
      return approved;
    }
    if (status == AppointmentStatus.completed) {
      return _apply(
        AppointmentAction.complete,
        approved,
        by: _staffActor(staff),
        at: startsAt,
      );
    }
    if (status == AppointmentStatus.noShow) {
      return _apply(
        AppointmentAction.markNoShow,
        approved,
        by: _staffActor(staff),
        at: startsAt.add(Duration(minutes: _noShowToleranceMinutes)),
      );
    }
    if (status == AppointmentStatus.cancelledByStaff) {
      return _apply(
        AppointmentAction.cancelByStaff,
        approved,
        by: _staffActor(staff),
        at: startsAt.subtract(Duration(minutes: _statusChangeLeadMinutes)),
        reason: 'Klinik çalışma planında değişiklik yapıldı.',
      );
    }
    throw StateError(
      'Unsupported target status for the demo scenario: $status',
    );
  }

  Appointment _apply(
    AppointmentAction action,
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
    String? reason,
  }) {
    final result = action.apply(appointment, by: by, at: at, reason: reason);
    if (result.isNotSuccess) {
      throw StateError(
        'Could not build a demo appointment history: ${result.errorCode}',
      );
    }
    final transitioned = result.appointment;
    if (transitioned == null) {
      throw StateError(
        'A successful appointment action must return its result.',
      );
    }
    return transitioned;
  }

  AppointmentActor _staffActor(Staff staff) {
    if (staff.role == UserRole.doctor) {
      return StaffAppointmentActor.doctor(id: staff.id);
    }
    return StaffAppointmentActor.technician(id: staff.id);
  }

  DateTime _dateTimeAt(CalendarDate date, int minuteOfDay) {
    return DateTime(
      date.year,
      date.month,
      date.day,
      minuteOfDay ~/ _minutesPerHour,
      minuteOfDay % _minutesPerHour,
    );
  }

  CalendarDate _dateOffset(CalendarDate date, int dayOffset) {
    final shiftedDate = DateTime.utc(
      date.year,
      date.month,
      date.day + dayOffset,
    );
    return CalendarDate.fromDateTime(shiftedDate);
  }

  MedicalService _serviceNamed(List<MedicalService> services, String name) {
    return services.singleWhere(
      (MedicalService service) => service.name == name,
    );
  }

  String _demoId(String kind, int ordinal) => 'demo-$kind-$ordinal';
}
