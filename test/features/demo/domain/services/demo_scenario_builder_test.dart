import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/admin_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/staff_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action_transition.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/services/demo_scenario_builder.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';

void main() {
  AppointmentActor actorFor(AppointmentStatusChange change) {
    return switch (change.byRole) {
      UserRole.patient => PatientAppointmentActor(id: change.byUserId),
      UserRole.doctor => StaffAppointmentActor.doctor(id: change.byUserId),
      UserRole.technician => StaffAppointmentActor.technician(
        id: change.byUserId,
      ),
      UserRole.admin => AdminAppointmentActor(id: change.byUserId),
    };
  }

  AppointmentAction actionFor(AppointmentStatus status) {
    return switch (status) {
      AppointmentStatus.pending => throw StateError(
        'Pending is the initial state.',
      ),
      AppointmentStatus.approved => AppointmentAction.approve,
      AppointmentStatus.rejected => AppointmentAction.reject,
      AppointmentStatus.cancelledByPatient => AppointmentAction.cancelByPatient,
      AppointmentStatus.cancelledByStaff => AppointmentAction.cancelByStaff,
      AppointmentStatus.completed => AppointmentAction.complete,
      AppointmentStatus.noShow => AppointmentAction.markNoShow,
    };
  }

  final today = CalendarDate(year: 2026, month: 11, day: 15);
  const accounts = DemoAccounts(
    doctorUid: 'linked-doctor-uid',
    doctorFullName: 'Dr. Demo Doctor',
    doctorEmail: 'doctor@example.test',
    patientUid: 'linked-patient-uid',
    patientFullName: 'Demo Patient',
    patientEmail: 'patient@example.test',
  );
  final builder = DemoScenarioBuilder(
    clock: FixedClock(DateTime(2026, 11, 15, 12, 30)),
    accounts: accounts,
  );
  final dataSet = builder.build();

  group('DemoScenarioBuilder', () {
    test('builds the approved scenario counts and all service kinds', () {
      expect(dataSet.branches, hasLength(2));
      expect(dataSet.departments, hasLength(4));
      expect(dataSet.staff, hasLength(6));
      expect(dataSet.patients, hasLength(8));
      expect(dataSet.appointments, hasLength(20));
      expect(dataSet.services.whereType<Examination>(), isNotEmpty);
      expect(dataSet.services.whereType<LabTest>(), isNotEmpty);
      expect(dataSet.services.whereType<RadiologyService>(), isNotEmpty);
      expect(dataSet.services, hasLength(7));
      expect(dataSet.staff.whereType<Doctor>(), hasLength(4));
      expect(dataSet.staff.whereType<Technician>(), hasLength(2));
    });

    test('uses linked accounts and deterministic ids for other profiles', () {
      expect(dataSet.staff.first.id, accounts.doctorUid);
      expect(dataSet.patients.first.id, accounts.patientUid);
      expect(dataSet.staff.first.fullName, accounts.doctorFullName);
      expect(dataSet.staff.first.email, accounts.doctorEmail);
      expect(dataSet.patients.first.fullName, accounts.patientFullName);
      expect(dataSet.patients.first.email, accounts.patientEmail);
      expect(dataSet.staff.skip(1).map((Staff member) => member.id), [
        'demo-staff-2',
        'demo-staff-3',
        'demo-staff-4',
        'demo-staff-5',
        'demo-staff-6',
      ]);
      expect(dataSet.patients.skip(1).map((Patient patient) => patient.id), [
        'demo-patient-2',
        'demo-patient-3',
        'demo-patient-4',
        'demo-patient-5',
        'demo-patient-6',
        'demo-patient-7',
        'demo-patient-8',
      ]);
      expect(dataSet.demoRecordIds, contains(accounts.doctorUid));
      expect(dataSet.demoRecordIds, contains(accounts.patientUid));
      expect(
        dataSet.appointments.any(
          (Appointment appointment) =>
              appointment.patientId == accounts.patientUid,
        ),
        isTrue,
      );
    });

    test('places appointments relative to the injected clock date', () {
      expect(dataSet.referenceDate, today);
      for (final appointment in dataSet.appointments) {
        final dayOffset = DateTime(
          appointment.date.year,
          appointment.date.month,
          appointment.date.day,
        ).difference(DateTime(today.year, today.month, today.day)).inDays;
        expect(dayOffset, inInclusiveRange(-6, 6));
      }

      final todayAppointments = dataSet.appointments
          .where((Appointment appointment) => appointment.date == today)
          .toList();
      expect(todayAppointments, hasLength(6));
      expect(
        todayAppointments
            .where(
              (Appointment appointment) =>
                  appointment.status == AppointmentStatus.completed,
            )
            .length,
        2,
      );
      expect(
        todayAppointments
            .where(
              (Appointment appointment) =>
                  appointment.status == AppointmentStatus.approved,
            )
            .length,
        2,
      );
      expect(
        todayAppointments
            .where(
              (Appointment appointment) =>
                  appointment.status == AppointmentStatus.noShow,
            )
            .length,
        1,
      );
      expect(
        todayAppointments
            .where(
              (Appointment appointment) =>
                  appointment.status == AppointmentStatus.pending,
            )
            .length,
        1,
      );

      final priorAppointments = dataSet.appointments.where(
        (Appointment appointment) => appointment.date.isBefore(today),
      );
      expect(priorAppointments, hasLength(6));
      expect(
        priorAppointments.any(
          (Appointment appointment) =>
              appointment.status == AppointmentStatus.completed,
        ),
        isTrue,
      );
      expect(
        priorAppointments.any((Appointment appointment) {
          final reason = appointment.statusReason;
          return appointment.status == AppointmentStatus.cancelledByStaff &&
              reason != null &&
              reason.isNotEmpty;
        }),
        isTrue,
      );
      expect(
        priorAppointments.any((Appointment appointment) {
          final reason = appointment.statusReason;
          return appointment.status == AppointmentStatus.rejected &&
              reason != null &&
              reason.isNotEmpty;
        }),
        isTrue,
      );
      expect(
        dataSet.appointments.any(
          (Appointment appointment) =>
              appointment.date.isAfter(today) &&
              appointment.status == AppointmentStatus.pending,
        ),
        isTrue,
      );
      expect(
        dataSet.appointments.where(
          (Appointment appointment) => appointment.date.isAfter(today),
        ),
        hasLength(8),
      );
      expect(
        dataSet.appointments.any(
          (Appointment appointment) =>
              appointment.date.isAfter(today) &&
              appointment.status == AppointmentStatus.approved,
        ),
        isTrue,
      );
    });

    test('uses valid action histories for every appointment', () {
      for (final appointment in dataSet.appointments) {
        expect(appointment.patientName.trim(), isNotEmpty);
        expect(appointment.history.first.status, AppointmentStatus.pending);
        expect(appointment.history.last.status, appointment.status);
        for (int index = 1; index < appointment.history.length; index++) {
          expect(
            appointment.history[index - 1].at.isBefore(
              appointment.history[index].at,
            ),
            isTrue,
          );
        }

        final firstChange = appointment.history.first;
        final initial = Appointment.restore(
          id: appointment.id,
          patientId: appointment.patientId,
          patientName: appointment.patientName,
          staffId: appointment.staffId,
          branchId: appointment.branchId,
          departmentId: appointment.departmentId,
          serviceId: appointment.serviceId,
          serviceName: appointment.serviceName,
          fee: appointment.fee,
          date: appointment.date,
          range: appointment.range,
          status: AppointmentStatus.pending,
          history: [firstChange],
        );
        final replayed = appointment.history.skip(1).fold(initial, (
          Appointment current,
          AppointmentStatusChange change,
        ) {
          final actor = actorFor(change);
          final action = actionFor(change.status);
          final result = action.apply(
            current,
            by: actor,
            at: change.at,
            reason: change.reason,
          );
          expect(result.isSuccess, isTrue);
          final next = result.appointment;
          if (next == null) {
            fail('A successful transition must return its appointment.');
          }
          return next;
        });
        expect(replayed, appointment);
      }
    });

    test(
      'keeps slots aligned, available, within branch hours and non-overlapping',
      () {
        final availabilityByStaff = {
          for (final StaffAvailability availability in dataSet.availabilities)
            availability.staffId: availability,
        };
        final branchById = {
          for (final Branch branch in dataSet.branches) branch.id: branch,
        };
        final departmentIds = dataSet.departments
            .map((Department department) => department.id)
            .toSet();
        final serviceById = {
          for (final MedicalService service in dataSet.services)
            service.id: service,
        };
        final staffById = {
          for (final Staff member in dataSet.staff) member.id: member,
        };
        final patientIds = dataSet.patients.map((Patient p) => p.id).toSet();

        for (final appointment in dataSet.appointments) {
          final availability = availabilityByStaff[appointment.staffId];
          final branch = branchById[appointment.branchId];
          final service = serviceById[appointment.serviceId];
          final staff = staffById[appointment.staffId];
          if (availability == null) {
            fail('Every appointment must have staff availability.');
          }
          if (branch == null) {
            fail('Every appointment must reference a branch.');
          }
          if (service == null) {
            fail('Every appointment must reference a service.');
          }
          if (staff == null) {
            fail('Every appointment must reference a staff profile.');
          }
          expect(departmentIds, contains(appointment.departmentId));
          expect(patientIds, contains(appointment.patientId));
          expect(appointment.patientName.trim(), isNotEmpty);
          expect(staff.branchId, appointment.branchId);
          expect(staff.departmentId, appointment.departmentId);
          expect(staff.serviceIds, contains(service.id));
          expect(staff.canProvide(service), isTrue);
          expect(service.branchId, appointment.branchId);
          expect(service.departmentId, appointment.departmentId);
          expect(availability.branchId, appointment.branchId);
          expect(
            availability
                .windowsOn(appointment.date)
                .any((window) => window.range.encloses(appointment.range)),
            isTrue,
          );
          expect(
            branch.workingHours
                .rangesOn(appointment.date.weekday)
                .any(
                  (TimeRange opening) => opening.encloses(appointment.range),
                ),
            isTrue,
          );
          expect(appointment.range.start.minute % 5, 0);
          expect(appointment.range.durationMinutes % 5, 0);
        }

        for (
          int firstIndex = 0;
          firstIndex < dataSet.appointments.length;
          firstIndex++
        ) {
          for (
            int secondIndex = firstIndex + 1;
            secondIndex < dataSet.appointments.length;
            secondIndex++
          ) {
            final first = dataSet.appointments[firstIndex];
            final second = dataSet.appointments[secondIndex];
            if (first.staffId == second.staffId && first.date == second.date) {
              expect(first.range.overlaps(second.range), isFalse);
            }
          }
        }
      },
    );

    test('does not assign a laboratory test to dermatology', () {
      final departmentById = {
        for (final Department department in dataSet.departments)
          department.id: department,
      };
      final dermatologyId = dataSet.departments
          .singleWhere(
            (Department department) => department.name == 'Dermatoloji',
          )
          .id;

      for (final LabTest service in dataSet.services.whereType<LabTest>()) {
        final department = departmentById[service.departmentId];
        if (department == null) {
          fail('Every laboratory service must reference a department.');
        }
        expect(department.id, isNot(dermatologyId));
      }
    });

    test('returns equal data sets for repeated builds', () {
      expect(builder.build(), dataSet);
    });

    test('uses weekly availability and branch hours for every weekday', () {
      for (final Branch branch in dataSet.branches) {
        for (final Weekday weekday in Weekday.values) {
          final ranges = branch.workingHours.rangesOn(weekday);
          expect(ranges, hasLength(1));
          expect(ranges.single.start.minute % 5, 0);
          expect(ranges.single.durationMinutes % 5, 0);
        }
      }
      for (final StaffAvailability availability in dataSet.availabilities) {
        expect(availability.weekly, hasLength(Weekday.values.length));
        for (final window in availability.weekly) {
          expect(window.range.start.minute % 5, 0);
          expect(window.range.durationMinutes % 5, 0);
        }
      }
    });
  });
}
