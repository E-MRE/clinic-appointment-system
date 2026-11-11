import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/book_appointment_use_case.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/book_appointment_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/book_appointment_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/booking_selection.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../doubles/patient_appointment_repository.dart';
import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  final service = fixtures.services[1];
  final murat = fixtures.staff[1];
  final tuesday = CalendarDate(year: 2026, month: 10, day: 20);
  final slot = fixtures.range(9, 40, 20);
  final patient = PatientAppointmentActor(id: fixtures.patient.id);
  late PatientAppointmentRepository repository;
  late BookAppointmentCubit cubit;

  final schedule = StaffWeekSchedule(
    request: StaffWeekScheduleRequest(
      staff: murat,
      service: service,
      weekStart: fixtures.weekStart,
      branchHours: fixtures.branchHours,
    ),
    availability: fixtures.muratAvailability,
    bookedSlots: const [],
    now: fixtures.now,
  );

  BookingSelection selection() {
    return BookingSelection.initial(
      currentWeekStart: fixtures.weekStart,
    ).withService(service).withStaff(murat).withDate(tuesday).withSlot(slot);
  }

  setUp(() {
    repository = PatientAppointmentRepository();
    final clock = FixedClock(fixtures.now);
    cubit = BookAppointmentCubit(
      BookAppointmentUseCase(repository, clock),
      clock,
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.events.close();
    await repository.bookedSlots.close();
  });

  Future<void> submit({
    BookingSelection? choices,
    PatientAppointmentActor? by,
    String? patientName,
  }) {
    return cubit.submit(
      selection: choices ?? selection(),
      schedule: schedule,
      patient: by ?? patient,
      patientName: patientName ?? fixtures.patient.fullName,
    );
  }

  test('requests the chosen slot as a pending appointment', () async {
    final states = <BookAppointmentState>[];
    final subscription = cubit.stream.listen(states.add);
    await submit();
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();
    expect(states, [
      isA<BookAppointmentInProgress>(),
      isA<BookAppointmentSuccess>(),
    ]);
    final candidate = repository.bookedCandidates.single;
    expect(candidate.patientId, fixtures.patient.id);
    expect(candidate.patientName, fixtures.patient.fullName);
    expect(candidate.staffId, 'murat');
    expect(candidate.branchId, 'branch');
    expect(candidate.departmentId, 'internal');
    expect(candidate.serviceId, 'internal-exam');
    expect(candidate.serviceName, 'Dahiliye Muayenesi');
    expect(candidate.fee, service.fee);
    expect(candidate.date, tuesday);
    expect(candidate.range, slot);
    expect(candidate.status, AppointmentStatus.pending);
    expect(candidate.history.single.at, fixtures.now);
    final stored = (cubit.state as BookAppointmentSuccess).appointment;
    expect(stored.id, 'booked');
  });

  test('a rule violation inside the transaction reports its code', () async {
    final past = selection()
        .withDate(fixtures.weekStart)
        .withSlot(fixtures.range(9, 0, 20));
    await submit(choices: past);
    expect(
      (cubit.state as BookAppointmentFailure).errorCode,
      AppointmentErrorCode.inPast,
    );
  });

  test('a repository failure reports its code', () async {
    repository.bookFailure = AppointmentErrorCode.staffOverlap;
    await submit();
    expect(
      (cubit.state as BookAppointmentFailure).errorCode,
      AppointmentErrorCode.staffOverlap,
    );
  });

  test('an incomplete selection sends nothing', () async {
    await submit(choices: selection().withoutSlot());
    expect(cubit.state, isA<BookAppointmentIdle>());
    expect(repository.bookedCandidates, isEmpty);
  });

  test('ignores a second submit while the first runs', () async {
    final pending = Completer<DataResult<Appointment>>();
    repository.bookPending = pending;
    final first = submit();
    await submit();
    expect(repository.bookedCandidates, hasLength(1));
    pending.complete(
      DataResult.success(data: repository.bookedCandidates.single.withId('x')),
    );
    await first;
    expect(cubit.state, isA<BookAppointmentSuccess>());
    repository.bookPending = null;
    await submit();
    expect(repository.bookedCandidates, hasLength(2));
  });

  test('a result after close is ignored', () async {
    final pending = Completer<DataResult<Appointment>>();
    repository.bookPending = pending;
    final request = submit();
    await cubit.close();
    pending.complete(
      DataResult.success(data: repository.bookedCandidates.single.withId('x')),
    );
    await request;
    expect(cubit.state, isA<BookAppointmentInProgress>());
  });
}
