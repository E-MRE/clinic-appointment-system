import 'dart:async';

import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/data/repositories/firestore_appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action_transition.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_validator.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../staff_management/data/doubles/mock_collection.dart';
import '../../../staff_management/data/doubles/mock_document.dart';
import '../../../staff_management/data/doubles/mock_firestore.dart';
import '../../domain/support/booking_fixture.dart';
import '../doubles/mock_query.dart';
import '../support/serialized_fake_firestore.dart';

void main() {
  const f = BookingFixture();
  late SerializedFakeFirestore firestore;
  late FirestoreAppointmentRepository repository;
  setUp(() {
    firestore = SerializedFakeFirestore();
    repository = FirestoreAppointmentRepository(firestore);
  });
  List<AppointmentViolation> check(
    Appointment candidate,
    List<BookedSlot> staffSlots,
    List<BookedSlot> patientSlots,
  ) {
    return const AppointmentValidator.standard().validate(
      candidate,
      f.context(
        staff: f.doctor(id: candidate.staffId),
        staffSlots: staffSlots,
        patientSlots: patientSlots,
      ),
    );
  }

  Future<Map<String, dynamic>> storedDocuments() async {
    final documents = <String, dynamic>{};
    for (final doc in (await firestore.collection('appointments').get()).docs) {
      documents[doc.reference.path] = doc.data();
    }
    for (final path in ['staffBookings/staff', 'patientBookings/patient']) {
      final snapshot = await firestore.doc('$path/days/2026-11-01').get();
      if (snapshot.exists) documents[snapshot.reference.path] = snapshot.data();
    }
    return documents;
  }

  test(
    'book writes exact appointment and both previously missing day documents',
    () async {
      final candidate = f.lifecycle.request();
      final result = await repository.book(
        candidate,
        (staff, patient) => check(candidate, staff, patient),
      );
      expect(result.isSuccess, isTrue);
      final saved = result.appointment;
      if (saved == null) fail('Booking must return its saved appointment.');
      expect(saved.id, isNotEmpty);
      final data = (await firestore.doc('appointments/${saved.id}').get())
          .data();
      expect(data, {
        'patientId': 'patient',
        'staffId': 'staff',
        'branchId': 'branch',
        'departmentId': 'department',
        'serviceId': 'service',
        'serviceName': 'Examination',
        'feeMinorUnits': 85000,
        'date': '2026-11-01',
        'start': '10:00',
        'end': '10:30',
        'status': 'pending',
        'history': [
          {
            'status': 'pending',
            'byUserId': 'patient',
            'byRole': 'patient',
            'at': Timestamp.fromDate(f.lifecycle.requestedAt),
          },
        ],
        'createdAt': isA<Timestamp>(),
        'updatedAt': isA<Timestamp>(),
      });
      for (final path in ['staffBookings/staff', 'patientBookings/patient']) {
        expect((await firestore.doc('$path/days/2026-11-01').get()).data(), {
          'slots': [
            {'appointmentId': saved.id, 'start': '10:00', 'end': '10:30'},
          ],
          'lastAppointmentId': saved.id,
          'updatedAt': isA<Timestamp>(),
        });
      }
      expect(
        (await repository.watchPatientAppointments('patient').first).data,
        [saved],
      );
    },
  );
  Future<Appointment> book(Appointment candidate) async {
    final result = await repository.book(
      candidate,
      (staff, patient) => check(candidate, staff, patient),
    );
    final saved = result.appointment;
    if (saved == null) {
      fail(
        'Expected booking success: ${result.errorCode} ${result.violations}',
      );
    }
    return saved;
  }

  final otherEntries = [
    {'appointmentId': 'earlier', 'start': '09:00', 'end': '09:30'},
    {'appointmentId': 'later', 'start': '11:00', 'end': '11:30'},
  ];
  Future<void> seedDays() async {
    for (final path in ['staffBookings/staff', 'patientBookings/patient']) {
      await firestore.doc('$path/days/2026-11-01').set({
        'slots': otherEntries,
        'lastAppointmentId': 'later',
        'updatedAt': Timestamp.fromDate(f.lifecycle.requestedAt),
      });
    }
  }

  test('book appends after other entries in both day documents', () async {
    await seedDays();
    final saved = await book(f.lifecycle.request());
    for (final path in ['staffBookings/staff', 'patientBookings/patient']) {
      expect((await firestore.doc('$path/days/2026-11-01').get()).data(), {
        'slots': [
          ...otherEntries,
          {'appointmentId': saved.id, 'start': '10:00', 'end': '10:30'},
        ],
        'lastAppointmentId': saved.id,
        'updatedAt': isA<Timestamp>(),
      });
    }
  });

  for (final existing in [false, true]) {
    test(
      'violations return without any writes (existing day: $existing)',
      () async {
        if (existing) await seedDays();
        final before = await storedDocuments();
        final violations = [
          const AppointmentViolation(AppointmentErrorCode.outsideAvailability),
        ];
        final result = await repository.book(
          f.lifecycle.request(),
          (_, _) => violations,
        );
        expect(result.isNotSuccess, isTrue);
        expect(result.appointment, isNull);
        expect(result.errorCode, isNull);
        expect(result.violations, violations);
        violations.clear();
        expect(result.violations, hasLength(1));
        expect(() => result.violations.clear(), throwsUnsupportedError);
        expect(await storedDocuments(), before);
      },
    );
  }

  test(
    'concurrent same-slot bookings produce one success and one staffOverlap',
    () async {
      final first = f.appointment(patientId: 'first');
      final second = f.appointment(patientId: 'second');
      // The test harness serializes transactions; fake_cloud_firestore 4.4.0 does not.
      // This proves the closest observable outcome, not real SDK conflict retries.
      final results = await Future.wait([
        repository.book(
          first,
          (staff, patient) => check(first, staff, patient),
        ),
        repository.book(
          second,
          (staff, patient) => check(second, staff, patient),
        ),
      ]);
      expect(results.where((result) => result.isSuccess), hasLength(1));
      final failure = results.singleWhere((result) => result.isNotSuccess);
      expect(failure.violations.map((v) => v.code), [
        AppointmentErrorCode.staffOverlap,
      ]);
      expect(
        (await firestore.collection('appointments').get()).docs,
        hasLength(1),
      );
      expect(
        (await repository.watchStaffBookedSlots('staff', f.date).first).data,
        hasLength(1),
      );
    },
  );

  test(
    'patient overlap across different staff prevents the second booking',
    () async {
      final first = await book(f.lifecycle.request());
      final candidate = f.appointment(staffId: 'another');
      final result = await repository.book(
        candidate,
        (staff, patient) => check(candidate, staff, patient),
      );
      expect(result.violations.map((v) => v.code), [
        AppointmentErrorCode.patientOverlap,
      ]);
      expect(result.violations.single.conflict?.appointmentId, first.id);
      expect(
        (await firestore.doc('staffBookings/another/days/2026-11-01').get())
            .exists,
        isFalse,
      );
      expect(
        (await firestore.collection('appointments').get()).docs,
        hasLength(1),
      );
    },
  );

  const transitions = {
    AppointmentAction.approve: AppointmentStatus.approved,
    AppointmentAction.reject: AppointmentStatus.rejected,
    AppointmentAction.cancelByPatient: AppointmentStatus.cancelledByPatient,
    AppointmentAction.cancelByStaff: AppointmentStatus.cancelledByStaff,
    AppointmentAction.complete: AppointmentStatus.completed,
    AppointmentAction.markNoShow: AppointmentStatus.noShow,
  };
  for (final entry in transitions.entries) {
    test(
      '${entry.key.name} preserves unrelated entries and the exact audit shape',
      () async {
        await seedDays();
        final saved = await book(f.lifecycle.request());
        final staff = f.lifecycle.actor(UserRole.doctor, 'staff');
        if (entry.key == AppointmentAction.cancelByStaff ||
            entry.key == AppointmentAction.complete ||
            entry.key == AppointmentAction.markNoShow) {
          await repository.changeStatus(
            saved.id,
            (current) =>
                current.approve(by: staff, at: f.lifecycle.requestedAt),
          );
        }
        final reference = firestore.doc('appointments/${saved.id}');
        final before = (await reference.get()).data();
        final staffDay = firestore.doc('staffBookings/staff/days/2026-11-01');
        final patientDay = firestore.doc(
          'patientBookings/patient/days/2026-11-01',
        );
        final beforeStaff = (await staffDay.get()).data();
        final beforePatient = (await patientDay.get()).data();
        final by = switch (entry.key) {
          AppointmentAction.cancelByPatient => f.lifecycle.patient,
          _ => staff,
        };
        DateTime at = f.lifecycle.beforeStart;
        if (entry.key == AppointmentAction.complete ||
            entry.key == AppointmentAction.markNoShow) {
          at = f.lifecycle.atTolerance;
        }
        final result = await repository.changeStatus(
          saved.id,
          (current) => entry.key.apply(current, by: by, at: at),
        );
        expect(result.isSuccess, isTrue);
        expect(firestore.transactionReads, ['appointments/${saved.id}']);
        final updated = (await reference.get()).data();
        final previousHistory = before?['history'] as List<dynamic>;
        expect(updated, {
          ...?before,
          'status': entry.value.name,
          'history': [
            ...previousHistory,
            {
              'status': entry.value.name,
              'byUserId': by.id,
              'byRole': by.role.name,
              'at': Timestamp.fromDate(at),
            },
          ],
          'updatedAt': isA<Timestamp>(),
        });
        final next = result.appointment;
        if (next == null) fail('Expected updated appointment.');
        expect(next.status, entry.value);
        if (next.occupiesSlot) {
          expect((await staffDay.get()).data(), beforeStaff);
          expect((await patientDay.get()).data(), beforePatient);
        } else {
          for (final day in [staffDay, patientDay]) {
            expect((await day.get()).data(), {
              'slots': otherEntries,
              'lastAppointmentId': saved.id,
              'updatedAt': isA<Timestamp>(),
            });
          }
          // Released appointments no longer conflict; their original slot can be booked again.
          expect(
            (await repository.watchStaffBookedSlots('staff', f.date).first).data
                ?.map((slot) => slot.appointmentId),
            ['earlier', 'later'],
          );
          await book(f.lifecycle.request());
        }
      },
    );
  }

  test(
    'removing the last entry keeps both day documents with empty slots',
    () async {
      final saved = await book(f.lifecycle.request());
      await repository.changeStatus(
        saved.id,
        (current) => current.reject(
          by: f.lifecycle.actor(UserRole.admin, 'admin'),
          at: f.lifecycle.requestedAt,
        ),
      );
      for (final path in ['staffBookings/staff', 'patientBookings/patient']) {
        expect((await firestore.doc('$path/days/2026-11-01').get()).data(), {
          'slots': <dynamic>[],
          'lastAppointmentId': saved.id,
          'updatedAt': isA<Timestamp>(),
        });
      }
    },
  );

  test('failed lifecycle decisions leave every document untouched', () async {
    final saved = await book(f.lifecycle.request());
    final before = await storedDocuments();
    final result = await repository.changeStatus(
      saved.id,
      (current) =>
          current.approve(by: f.lifecycle.patient, at: f.lifecycle.requestedAt),
    );
    expect(result.errorCode, AppointmentErrorCode.notPermitted);
    expect(await storedDocuments(), before);
  });

  test(
    'missing appointment returns notFound without invoking the transition',
    () async {
      final result = await repository.changeStatus(
        'missing',
        (_) => throw StateError('Must not run'),
      );
      expect(result.errorCode, AppointmentErrorCode.notFound);
      expect(await storedDocuments(), isEmpty);
    },
  );

  test('only new pending requests can be booked', () async {
    for (final candidate in [
      f.appointment(id: 'saved'),
      f.appointment(status: AppointmentStatus.rejected),
    ]) {
      final result = await repository.book(candidate, (_, _) => []);
      expect(result.errorCode, AppointmentErrorCode.invalidTransition);
    }
    expect((await firestore.collection('appointments').get()).docs, isEmpty);
  });

  test(
    'patient and staff queries filter owners/dates and sort by date then start',
    () async {
      final early = await book(f.appointment(range: f.range('09:00', '09:30')));
      final late = await book(f.lifecycle.request());
      final tomorrowCandidate = f.appointment(
        date: CalendarDate(year: 2026, month: 11, day: 2),
      );
      // Query fixtures need a different weekday; booking rules are covered separately.
      final tomorrowResult = await repository.book(
        tomorrowCandidate,
        (_, _) => [],
      );
      final tomorrow = tomorrowResult.appointment;
      if (tomorrow == null) fail('Expected query fixture appointment.');
      final otherPatient = await book(
        f.appointment(
          patientId: 'other-patient',
          range: f.range('11:00', '11:30'),
        ),
      );
      final otherStaff = await book(
        f.appointment(patientId: 'other-patient', staffId: 'other-staff'),
      );
      final patient = await repository
          .watchPatientAppointments('patient')
          .first;
      expect(patient.data, [early, late, tomorrow]);
      final staff = await repository
          .watchStaffAppointments('staff', f.date, f.date)
          .first;
      expect(staff.data, [early, late, otherPatient]);
      expect(
        (await repository.watchPatientAppointments('other-patient').first).data,
        [otherStaff, otherPatient],
      );
      expect(
        (await repository
                .watchStaffAppointments('staff', f.date, tomorrow.date)
                .first)
            .data,
        [early, late, otherPatient, tomorrow],
      );
      expect(
        (await repository.watchPatientAppointments('missing').first).data,
        isEmpty,
      );
    },
  );

  test(
    'staff slots use owner and day document id, and missing days are empty',
    () async {
      await seedDays();
      final saved = await book(f.lifecycle.request());
      final result = await repository
          .watchStaffBookedSlots('staff', f.date)
          .first;
      expect(result.data, [
        f.slot(id: 'earlier', range: f.range('09:00', '09:30')),
        f.slot(id: 'later', range: f.range('11:00', '11:30')),
        saved.bookedSlot,
      ]);
      expect(
        (await repository.watchStaffBookedSlots('other', f.date).first).data,
        isEmpty,
      );
      expect(
        (await repository
                .watchStaffBookedSlots(
                  'staff',
                  CalendarDate(year: 2026, month: 11, day: 2),
                )
                .first)
            .data,
        isEmpty,
      );
    },
  );

  test(
    'malformed staff or patient projection returns invalidRecord and writes nothing',
    () async {
      for (final path in ['staffBookings/staff', 'patientBookings/patient']) {
        await firestore.doc('$path/days/2026-11-01').set({'slots': 'broken'});
        final before = await storedDocuments();
        final result = await repository.book(
          f.lifecycle.request(),
          (_, _) => [],
        );
        expect(result.errorCode, AppointmentErrorCode.invalidRecord);
        expect(await storedDocuments(), before);
        await firestore.doc('$path/days/2026-11-01').delete();
      }
    },
  );

  test(
    'malformed appointment returns invalidRecord in status and both list streams',
    () async {
      await firestore.doc('appointments/broken').set({
        'patientId': 'patient',
        'staffId': 'staff',
        'date': '2026-11-01',
        'start': '10:00',
      });
      final before = await storedDocuments();
      final result = await repository.changeStatus(
        'broken',
        (_) => throw StateError('Must not run'),
      );
      expect(result.errorCode, AppointmentErrorCode.invalidRecord);
      expect(await storedDocuments(), before);
      final patient = await repository
          .watchPatientAppointments('patient')
          .first;
      final staff = await repository
          .watchStaffAppointments('staff', f.date, f.date)
          .first;
      for (final result in [patient, staff]) {
        expect(result.isNotSuccess, isTrue);
        expect(result.message, AppointmentErrorCode.invalidRecord.name);
      }
    },
  );

  test(
    'malformed slot emits invalidRecord rather than a stream error',
    () async {
      await firestore.doc('staffBookings/staff/days/2026-11-01').set({
        'slots': [
          {'appointmentId': 'broken', 'start': '11:00', 'end': '10:00'},
        ],
        'lastAppointmentId': 'broken',
        'updatedAt': Timestamp.now(),
      });
      final result = await repository
          .watchStaffBookedSlots('staff', f.date)
          .first;
      expect(result.isNotSuccess, isTrue);
      expect(result.message, AppointmentErrorCode.invalidRecord.name);
    },
  );

  test(
    'Firebase transaction failures return error results for booking and status',
    () async {
      final db = MockFirestore();
      when(() => db.collection(any())).thenAnswer(
        (invocation) => firestore.collection(
          invocation.positionalArguments.single as String,
        ),
      );
      when(
        () => db.runTransaction<void>(any()),
      ).thenThrow(FirebaseException(plugin: 'firestore', code: 'unavailable'));
      final failingRepository = FirestoreAppointmentRepository(db);
      final booking = await failingRepository.book(
        f.lifecycle.request(),
        (_, _) => [],
      );
      final transition = await failingRepository.changeStatus(
        'id',
        (_) => throw StateError('Must not run'),
      );
      expect(booking.isNotSuccess, isTrue);
      expect(booking.errorCode, AppointmentErrorCode.unavailable);
      expect(transition.isNotSuccess, isTrue);
      expect(transition.errorCode, AppointmentErrorCode.unavailable);
      expect(await storedDocuments(), isEmpty);
    },
  );

  test(
    'Firebase errors during query construction emit error DataResults',
    () async {
      final db = MockFirestore();
      when(() => db.collection(any())).thenThrow(
        FirebaseException(plugin: 'firestore', code: 'permission-denied'),
      );
      final failingRepository = FirestoreAppointmentRepository(db);
      final results = [
        await failingRepository.watchPatientAppointments('patient').first,
        await failingRepository
            .watchStaffAppointments('staff', f.date, f.date)
            .first,
        await failingRepository.watchStaffBookedSlots('staff', f.date).first,
      ];
      for (final result in results) {
        expect(result.isNotSuccess, isTrue);
        expect(result.message, AppointmentErrorCode.unavailable.name);
      }
    },
  );

  test(
    'Firebase asynchronous errors emit error DataResults for all watches',
    () async {
      final db = MockFirestore();
      final collection = MockCollection();
      final query = MockQuery();
      final staff = MockDocument();
      final day = MockDocument();
      when(() => db.collection(any())).thenReturn(collection);
      when(
        () => collection.where('patientId', isEqualTo: 'patient'),
      ).thenReturn(query);
      when(
        () => collection.where('staffId', isEqualTo: 'staff'),
      ).thenReturn(query);
      when(
        () => query.where('date', isGreaterThanOrEqualTo: '2026-11-01'),
      ).thenReturn(query);
      when(
        () => query.where('date', isLessThanOrEqualTo: '2026-11-01'),
      ).thenReturn(query);
      when(() => query.orderBy(any())).thenReturn(query);
      when(() => query.snapshots()).thenAnswer(
        (_) => Stream.error(
          FirebaseException(plugin: 'firestore', code: 'unavailable'),
        ),
      );
      when(() => collection.doc('staff')).thenReturn(staff);
      when(() => staff.collection('days')).thenReturn(collection);
      when(() => collection.doc('2026-11-01')).thenReturn(day);
      when(() => day.snapshots()).thenAnswer(
        (_) => Stream.error(
          FirebaseException(plugin: 'firestore', code: 'unavailable'),
        ),
      );
      final failingRepository = FirestoreAppointmentRepository(db);
      final results = [
        await failingRepository.watchPatientAppointments('patient').first,
        await failingRepository
            .watchStaffAppointments('staff', f.date, f.date)
            .first,
        await failingRepository.watchStaffBookedSlots('staff', f.date).first,
      ];
      for (final result in results) {
        expect(result.isNotSuccess, isTrue);
        expect(result.message, AppointmentErrorCode.unavailable.name);
      }
    },
  );

  for (final invalid in [
    {'status': 'unknown'},
    {'date': '2026-02-30'},
    {'start': '9:00'},
    {'feeMinorUnits': -1},
    {'history': <dynamic>[]},
    {'status': 'approved'},
  ]) {
    test(
      'malformed appointment fields map to invalidRecord: $invalid',
      () async {
        final saved = await book(f.lifecycle.request());
        await firestore.doc('appointments/${saved.id}').update(invalid);
        final before = await storedDocuments();
        final transition = await repository.changeStatus(
          saved.id,
          (_) => throw StateError('Must not run'),
        );
        expect(transition.errorCode, AppointmentErrorCode.invalidRecord);
        expect(
          (await repository.watchPatientAppointments('patient').first).message,
          AppointmentErrorCode.invalidRecord.name,
        );
        expect(await storedDocuments(), before);
      },
    );
  }

  test('slot streams continue after malformed data is repaired', () async {
    final day = firestore.doc('staffBookings/staff/days/2026-11-01');
    await day.set({'slots': 'broken'});
    final iterator = StreamIterator(
      repository.watchStaffBookedSlots('staff', f.date),
    );
    try {
      expect(await iterator.moveNext(), isTrue);
      expect(iterator.current.message, AppointmentErrorCode.invalidRecord.name);
      await seedDays();
      expect(await iterator.moveNext(), isTrue);
      expect(iterator.current.isSuccess, isTrue);
      expect(iterator.current.data, hasLength(2));
    } finally {
      await iterator.cancel();
    }
  });
}
