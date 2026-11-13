import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_rule_check_kind.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_rule_check_factory.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  group('StaffRuleCheckFactory', () {
    // 2026-10-27 is a Tuesday (Weekday.tuesday).
    final tuesday = CalendarDate(year: 2026, month: 10, day: 27);
    final candidateRange = TimeRange(
      start: ClockTime(hour: 9, minute: 20),
      end: ClockTime(hour: 9, minute: 40),
    );
    final now = DateTime(2026, 10, 26, 10, 0);

    const doctor = Doctor(
      id: 'doc_1',
      fullName: 'Dr. Ayşe Yılmaz',
      email: 'ayse@example.com',
      branchId: 'branch_1',
      departmentId: 'dept_cardio',
      serviceIds: ['srv_exam', 'srv_echo'],
      specialty: 'Kardiyoloji',
    );

    final service = Examination(
      id: 'srv_exam',
      branchId: 'branch_1',
      departmentId: 'dept_cardio',
      name: 'Kardiyoloji Muayenesi',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(120000),
    );

    final standardBranchHours = WorkingHours({
      Weekday.tuesday: [
        TimeRange(
          start: ClockTime(hour: 8, minute: 30),
          end: ClockTime(hour: 18, minute: 0),
        ),
      ],
    });

    final standardAvailability = StaffAvailability(
      staffId: 'doc_1',
      branchId: 'branch_1',
      weekly: [
        WeeklyWindow(
          weekday: Weekday.tuesday,
          range: TimeRange(
            start: ClockTime(hour: 9, minute: 0),
            end: ClockTime(hour: 12, minute: 0),
          ),
        ),
      ],
    );

    Appointment makeAppointment({
      required String id,
      required AppointmentStatus status,
      CalendarDate? date,
      TimeRange? range,
      String staffId = 'doc_1',
      String serviceId = 'srv_exam',
    }) {
      return Appointment.restore(
        id: id,
        patientId: 'patient_1',
        patientName: 'Ahmet Demir',
        staffId: staffId,
        branchId: 'branch_1',
        departmentId: 'dept_cardio',
        serviceId: serviceId,
        serviceName: 'Kardiyoloji Muayenesi',
        fee: Money.minorUnits(120000),
        date: date ?? tuesday,
        range: range ?? candidateRange,
        status: status,
        history: [
          AppointmentStatusChange(
            status: status,
            byUserId: 'patient_1',
            byRole: UserRole.patient,
            at: DateTime(2026, 10, 26, 8, 0),
          ),
        ],
      );
    }

    final candidate = makeAppointment(
      id: 'req_candidate',
      status: AppointmentStatus.pending,
    );

    const factory = StaffRuleCheckFactory();

    testWidgets('all four pass with correct detail texts and messages', (
      tester,
    ) async {
      await loadTestTranslations(tester);

      final result = factory.create(
        request: candidate,
        staff: doctor,
        service: service,
        availability: standardAvailability,
        branchHours: standardBranchHours,
        appointments: const [],
        now: now,
      );

      expect(result.length, 4);
      expect(result.every((item) => item.passed), isTrue);

      // 1. Availability
      expect(result[0].kind, StaffRuleCheckKind.withinAvailability);
      expect(result[0].passed, isTrue);
      expect(result[0].detail, 'Salı 09:00–12:00');
      expect(result[0].message, 'Uygunluk aralığınızda (Salı 09:00–12:00)');

      // 2. Working Hours
      expect(result[1].kind, StaffRuleCheckKind.withinWorkingHours);
      expect(result[1].passed, isTrue);
      expect(result[1].detail, '08:30–18:00');
      expect(result[1].message, 'Şube çalışma saatleri içinde (08:30–18:00)');

      // 3. No Staff Overlap
      expect(result[2].kind, StaffRuleCheckKind.noStaffOverlap);
      expect(result[2].passed, isTrue);
      expect(result[2].message, 'Bu saatte onaylı başka randevunuz yok');

      // 4. Staff Provides Service
      expect(result[3].kind, StaffRuleCheckKind.staffProvidesService);
      expect(result[3].passed, isTrue);
      expect(result[3].message, 'Bu hizmeti veriyorsunuz');
    });

    testWidgets(
      'withinAvailability failing on its own gives failed item with failing text',
      (tester) async {
        await loadTestTranslations(tester);

        // Window is in afternoon: 14:00-17:00
        final afternoonAvailability = StaffAvailability(
          staffId: 'doc_1',
          branchId: 'branch_1',
          weekly: [
            WeeklyWindow(
              weekday: Weekday.tuesday,
              range: TimeRange(
                start: ClockTime(hour: 14, minute: 0),
                end: ClockTime(hour: 17, minute: 0),
              ),
            ),
          ],
        );

        final result = factory.create(
          request: candidate,
          staff: doctor,
          service: service,
          availability: afternoonAvailability,
          branchHours: standardBranchHours,
          appointments: const [],
          now: now,
        );

        expect(result.every((item) => item.passed), isFalse);

        expect(result[0].kind, StaffRuleCheckKind.withinAvailability);
        expect(result[0].passed, isFalse);
        expect(result[0].message, 'Uygunluk aralığınızın dışında');

        expect(result[1].passed, isTrue);
        expect(result[2].passed, isTrue);
        expect(result[3].passed, isTrue);
      },
    );

    testWidgets(
      'withinWorkingHours failing on its own gives failed item with failing text',
      (tester) async {
        await loadTestTranslations(tester);

        // Branch opens at 10:00, while candidate is 09:20-09:40
        final lateBranchHours = WorkingHours({
          Weekday.tuesday: [
            TimeRange(
              start: ClockTime(hour: 10, minute: 0),
              end: ClockTime(hour: 18, minute: 0),
            ),
          ],
        });

        final result = factory.create(
          request: candidate,
          staff: doctor,
          service: service,
          availability: standardAvailability,
          branchHours: lateBranchHours,
          appointments: const [],
          now: now,
        );

        expect(result[1].kind, StaffRuleCheckKind.withinWorkingHours);
        expect(result[1].passed, isFalse);
        expect(result[1].message, 'Şube çalışma saatlerinin dışında');

        expect(result[2].passed, isTrue);
        expect(result[3].passed, isTrue);
      },
    );

    testWidgets(
      'noStaffOverlap failing on its own gives failed item with failing text',
      (tester) async {
        await loadTestTranslations(tester);

        final approvedConflicting = makeAppointment(
          id: 'approved_conflict',
          status: AppointmentStatus.approved,
        );

        final result = factory.create(
          request: candidate,
          staff: doctor,
          service: service,
          availability: standardAvailability,
          branchHours: standardBranchHours,
          appointments: [approvedConflicting],
          now: now,
        );

        expect(result[2].kind, StaffRuleCheckKind.noStaffOverlap);
        expect(result[2].passed, isFalse);
        expect(result[2].message, 'Bu saatte onaylı başka bir randevunuz var');

        expect(result[0].passed, isTrue);
        expect(result[1].passed, isTrue);
        expect(result[3].passed, isTrue);
      },
    );

    testWidgets(
      'staffProvidesService failing on its own gives failed item with failing text',
      (tester) async {
        await loadTestTranslations(tester);

        const doctorWithoutService = Doctor(
          id: 'doc_1',
          fullName: 'Dr. Ayşe Yılmaz',
          email: 'ayse@example.com',
          branchId: 'branch_1',
          departmentId: 'dept_cardio',
          serviceIds: ['other_service'],
          specialty: 'Kardiyoloji',
        );

        final result = factory.create(
          request: candidate,
          staff: doctorWithoutService,
          service: service,
          availability: standardAvailability,
          branchHours: standardBranchHours,
          appointments: const [],
          now: now,
        );

        expect(result[3].kind, StaffRuleCheckKind.staffProvidesService);
        expect(result[3].passed, isFalse);
        expect(result[3].message, 'Bu hizmeti vermiyorsunuz');

        expect(result[0].passed, isTrue);
        expect(result[1].passed, isTrue);
        expect(result[2].passed, isTrue);
      },
    );

    testWidgets(
      'overlap edge case: reviewed appointment own slot is not an overlap',
      (tester) async {
        await loadTestTranslations(tester);

        // The candidate itself is in the appointments list
        final result = factory.create(
          request: candidate,
          staff: doctor,
          service: service,
          availability: standardAvailability,
          branchHours: standardBranchHours,
          appointments: [candidate],
          now: now,
        );

        expect(result[2].kind, StaffRuleCheckKind.noStaffOverlap);
        expect(result[2].passed, isTrue);
        expect(result[2].message, 'Bu saatte onaylı başka randevunuz yok');
      },
    );

    testWidgets('overlap edge case: a pending neighbour is not an overlap', (
      tester,
    ) async {
      await loadTestTranslations(tester);

      final pendingNeighbour = makeAppointment(
        id: 'pending_neighbour',
        status: AppointmentStatus.pending,
      );

      final result = factory.create(
        request: candidate,
        staff: doctor,
        service: service,
        availability: standardAvailability,
        branchHours: standardBranchHours,
        appointments: [pendingNeighbour],
        now: now,
      );

      expect(result[2].kind, StaffRuleCheckKind.noStaffOverlap);
      expect(result[2].passed, isTrue);
    });

    testWidgets(
      'overlap edge case: an approved neighbour at the same time is an overlap',
      (tester) async {
        await loadTestTranslations(tester);

        final approvedNeighbour = makeAppointment(
          id: 'approved_neighbour',
          status: AppointmentStatus.approved,
        );

        final result = factory.create(
          request: candidate,
          staff: doctor,
          service: service,
          availability: standardAvailability,
          branchHours: standardBranchHours,
          appointments: [approvedNeighbour],
          now: now,
        );

        expect(result[2].kind, StaffRuleCheckKind.noStaffOverlap);
        expect(result[2].passed, isFalse);
        expect(result[2].message, 'Bu saatte onaylı başka bir randevunuz var');
      },
    );
  });
}
