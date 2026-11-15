import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/data/converters/calendar_date_converter.dart';
import 'package:clinic_appointment_system/features/appointments/data/models/booking_day_model.dart';
import 'package:clinic_appointment_system/features/appointments/data/repositories/firestore_appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/no_patient_overlap_rule.dart';
import 'package:clinic_appointment_system/features/demo/data/repositories/firestore_demo_data_repository.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/services/demo_scenario_builder.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model_factory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../appointments/domain/support/booking_fixture.dart';

void main() {
  final dataSet = DemoScenarioBuilder(
    clock: FixedClock(DateTime(2026, 11, 15, 12)),
    accounts: const DemoAccounts(
      doctorUid: 'linked-doctor',
      doctorFullName: 'Dr. Servet Yılmaz',
      doctorEmail: 'servet@doktor.com',
      patientUid: 'linked-patient',
      patientFullName: 'Remzi Pala',
      patientEmail: 'remzi@pala.com',
    ),
  ).build();

  test(
    'replaces demo records, owns institutions, and preserves legacy users and appointments',
    () async {
      final firestore = FakeFirebaseFirestore();
      final repository = FirestoreDemoDataRepository(
        firestore,
        const MedicalServiceModelFactory(),
      );
      final linkedDoctorProfile = {
        'role': 'doctor',
        'fullName': 'Existing Doctor Name',
        'email': 'servet@doktor.com',
        'branchId': 'old-branch',
        'departmentId': 'old-department',
        'specialty': 'Existing Specialty',
        'serviceIds': ['old-service'],
        'createdAt': DateTime(2020),
      };
      final linkedPatientProfile = {
        'role': 'patient',
        'fullName': 'Existing Patient Name',
        'email': 'remzi@pala.com',
        'createdAt': DateTime(2020),
      };
      await firestore
          .collection(FirestoreConstants.users)
          .doc('linked-doctor')
          .set(linkedDoctorProfile);
      await firestore
          .collection(FirestoreConstants.users)
          .doc('linked-patient')
          .set(linkedPatientProfile);
      await firestore
          .collection(FirestoreConstants.staffAvailability)
          .doc('linked-doctor')
          .set({
            FirestoreConstants.branchId: 'old-branch',
            FirestoreConstants.weekly: <String, dynamic>{},
            FirestoreConstants.oneOff: <dynamic>[],
          });
      for (int index = 0; index < 501; index++) {
        await firestore
            .collection(FirestoreConstants.clinics)
            .doc('legacy-clinic-$index')
            .set({FirestoreConstants.name: 'Legacy $index'});
      }
      await firestore
          .collection(FirestoreConstants.branches)
          .doc('old-branch')
          .set({
            FirestoreConstants.clinicId: 'old-clinic',
            FirestoreConstants.isDemo: true,
          });
      await firestore
          .collection(FirestoreConstants.departments)
          .doc('old-department')
          .set({
            FirestoreConstants.branchId: 'old-branch',
            FirestoreConstants.isDemo: true,
          });
      await firestore
          .collection(FirestoreConstants.services)
          .doc('old-service')
          .set({
            FirestoreConstants.branchId: 'old-branch',
            FirestoreConstants.isDemo: true,
          });
      await firestore
          .collection(FirestoreConstants.users)
          .doc('legacy-user')
          .set({
            FirestoreConstants.email: 'legacy@example.com',
            FirestoreConstants.isDemo: false,
          });
      await firestore
          .collection(FirestoreConstants.users)
          .doc('stale-demo-user')
          .set({FirestoreConstants.isDemo: true});
      await firestore
          .collection(FirestoreConstants.staffAvailability)
          .doc('stale-demo-staff')
          .set({FirestoreConstants.isDemo: true});
      await firestore
          .collection(FirestoreConstants.appointments)
          .doc('legacy-appointment')
          .set({
            FirestoreConstants.branchId: 'old-branch',
            FirestoreConstants.departmentId: 'old-department',
            FirestoreConstants.isDemo: false,
          });
      await firestore
          .collection(FirestoreConstants.appointments)
          .doc('stale-demo-appointment')
          .set({FirestoreConstants.isDemo: true});
      final staleStaffProjection = firestore
          .collection(FirestoreConstants.staffBookings)
          .doc('stale-demo-staff')
          .collection(FirestoreConstants.days)
          .doc('2026-11-15');
      await staleStaffProjection.set({FirestoreConstants.isDemo: true});
      final stalePatientProjection = firestore
          .collection(FirestoreConstants.patientBookings)
          .doc('stale-demo-patient')
          .collection(FirestoreConstants.days)
          .doc('2026-11-15');
      await stalePatientProjection.set({FirestoreConstants.isDemo: true});
      final legacyProjection = firestore
          .collection(FirestoreConstants.patientBookings)
          .doc('legacy-patient')
          .collection(FirestoreConstants.days)
          .doc('2026-11-15');
      await legacyProjection.set({
        FirestoreConstants.slots: <dynamic>[],
        FirestoreConstants.lastAppointmentId: 'legacy-appointment',
      });

      final result = await repository.replace(dataSet);

      expect(result.isSuccess, isTrue);
      final clinics = await firestore
          .collection(FirestoreConstants.clinics)
          .get();
      final branches = await firestore
          .collection(FirestoreConstants.branches)
          .get();
      final departments = await firestore
          .collection(FirestoreConstants.departments)
          .get();
      final services = await firestore
          .collection(FirestoreConstants.services)
          .get();
      expect(clinics.docs, hasLength(1));
      expect(clinics.docs.single.id, 'demo-clinic-1');
      expect(branches.docs, hasLength(2));
      expect(departments.docs, hasLength(4));
      expect(services.docs, hasLength(7));
      expect(clinics.docs.single.data()[FirestoreConstants.isDemo], isTrue);
      expect(
        (await firestore
                .collection(FirestoreConstants.users)
                .doc('legacy-user')
                .get())
            .exists,
        isTrue,
      );
      expect(
        (await firestore
                .collection(FirestoreConstants.users)
                .doc('stale-demo-user')
                .get())
            .exists,
        isFalse,
      );
      expect(
        (await firestore
                .collection(FirestoreConstants.appointments)
                .doc('legacy-appointment')
                .get())
            .exists,
        isTrue,
      );
      expect(
        (await firestore
                .collection(FirestoreConstants.appointments)
                .doc('stale-demo-appointment')
                .get())
            .exists,
        isFalse,
      );
      expect((await staleStaffProjection.get()).exists, isFalse);
      expect((await stalePatientProjection.get()).exists, isFalse);
      expect((await legacyProjection.get()).exists, isTrue);
      final doctor =
          (await firestore
                  .collection(FirestoreConstants.users)
                  .doc('linked-doctor')
                  .get())
              .data();
      expect(doctor?.containsKey(FirestoreConstants.isDemo), isFalse);
      expect(doctor?[FirestoreConstants.branchId], 'demo-branch-1');
      expect(doctor?[FirestoreConstants.departmentId], 'demo-department-1');
      expect(doctor?[FirestoreConstants.serviceIds], ['demo-service-1']);
      expect(doctor?[FirestoreConstants.fullName], 'Existing Doctor Name');
      expect(doctor?[FirestoreConstants.email], 'servet@doktor.com');
      expect(doctor?[FirestoreConstants.specialty], 'Existing Specialty');
      final patient =
          (await firestore
                  .collection(FirestoreConstants.users)
                  .doc('linked-patient')
                  .get())
              .data();
      expect(patient?.keys, unorderedEquals(linkedPatientProfile.keys));
      expect(patient?[FirestoreConstants.role], 'patient');
      expect(patient?[FirestoreConstants.fullName], 'Existing Patient Name');
      expect(patient?[FirestoreConstants.email], 'remzi@pala.com');
      expect(
        patient?[FirestoreConstants.createdAt],
        Timestamp.fromDate(DateTime(2020)),
      );
      final linkedAvailability =
          (await firestore
                  .collection(FirestoreConstants.staffAvailability)
                  .doc('linked-doctor')
                  .get())
              .data();
      expect(linkedAvailability?[FirestoreConstants.branchId], 'demo-branch-1');
      expect(
        linkedAvailability?.containsKey(FirestoreConstants.isDemo),
        isFalse,
      );

      final reservedAppointment = dataSet.appointments.firstWhere(
        (appointment) =>
            appointment.patientId == 'linked-patient' &&
            appointment.bookedSlot != null,
      );
      final dateId = const CalendarDateConverter().toJson(
        reservedAppointment.date,
      );
      final patientDayReference = firestore
          .collection(FirestoreConstants.patientBookings)
          .doc(reservedAppointment.patientId)
          .collection(FirestoreConstants.days)
          .doc(dateId);
      final patientDayData = (await patientDayReference.get()).data();
      expect(patientDayData?[FirestoreConstants.isDemo], isTrue);
      final patientDay = BookingDayModel.fromJson(dateId, patientDayData);
      expect(
        patientDay.slots.map((slot) => slot.appointmentId),
        contains(reservedAppointment.id),
      );
      const bookingFixture = BookingFixture();
      final candidate = bookingFixture.appointment(
        patientId: reservedAppointment.patientId,
        patientName: reservedAppointment.patientName,
        staffId: 'different-staff',
        serviceId: reservedAppointment.serviceId,
        date: reservedAppointment.date,
        range: reservedAppointment.range,
      );
      final bookingResult = await FirestoreAppointmentRepository(firestore)
          .book(candidate, (staffSlots, patientSlots) {
            final violation = const NoPatientOverlapRule().check(
              candidate,
              bookingFixture.context(patientSlots: patientSlots),
            );
            return violation == null ? [] : [violation];
          });
      expect(bookingResult.errorCode, AppointmentErrorCode.patientOverlap);

      final reloadResult = await repository.replace(dataSet);

      expect(reloadResult.isSuccess, isTrue);
      expect(
        (await firestore.collection(FirestoreConstants.appointments).get())
            .docs,
        hasLength(dataSet.appointments.length + 1),
      );
    },
  );

  test('protects an existing non-demo user with a deterministic id', () async {
    final firestore = FakeFirebaseFirestore();
    await firestore.collection(FirestoreConstants.clinics).doc('keep').set({
      FirestoreConstants.name: 'Keep until preflight succeeds',
    });
    await firestore
        .collection(FirestoreConstants.users)
        .doc('demo-staff-2')
        .set({FirestoreConstants.isDemo: false});
    final repository = FirestoreDemoDataRepository(
      firestore,
      const MedicalServiceModelFactory(),
    );

    final result = await repository.replace(dataSet);

    expect(result.isNotSuccess, isTrue);
    expect(result.errorCode, DemoErrorCode.recordIdConflict);
    expect(
      (await firestore.collection(FirestoreConstants.clinics).doc('keep').get())
          .exists,
      isTrue,
    );
  });

  test(
    'preserves real booking projections before replacing owned institutions',
    () async {
      final firestore = FakeFirebaseFirestore();
      final occupiedAppointment = dataSet.appointments.firstWhere(
        (appointment) => appointment.bookedSlot != null,
      );
      final dateId = const CalendarDateConverter().toJson(
        occupiedAppointment.date,
      );
      final realProjection = firestore
          .collection(FirestoreConstants.patientBookings)
          .doc(occupiedAppointment.patientId)
          .collection(FirestoreConstants.days)
          .doc(dateId);
      await realProjection.set({FirestoreConstants.isDemo: false});
      await firestore.collection(FirestoreConstants.clinics).doc('keep').set({
        FirestoreConstants.name: 'Keep when a real booking conflicts',
      });
      final repository = FirestoreDemoDataRepository(
        firestore,
        const MedicalServiceModelFactory(),
      );

      final result = await repository.replace(dataSet);

      expect(result.errorCode, DemoErrorCode.recordIdConflict);
      expect((await realProjection.get()).exists, isTrue);
      expect(
        (await firestore
                .collection(FirestoreConstants.clinics)
                .doc('keep')
                .get())
            .exists,
        isTrue,
      );
      expect(
        (await firestore.collection(FirestoreConstants.clinics).get()).docs,
        hasLength(1),
      );
    },
  );
}
