import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/models/appointment_booking_request.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/book_appointment_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../doubles/fake_appointment_repository.dart';
import '../doubles/mock_clock.dart';
import '../support/booking_fixture.dart';

void main() {
  const f = BookingFixture();
  late FakeAppointmentRepository repository;
  late Clock clock;
  late BookAppointmentUseCase useCase;
  AppointmentBookingRequest request() => AppointmentBookingRequest(
    candidate: f.lifecycle.request(),
    staff: f.doctor(),
    service: f.service(),
    availability: f.availability(),
    branchHours: f.hours,
  );
  setUp(() {
    repository = FakeAppointmentRepository();
    clock = MockClock();
    when(clock.now).thenReturn(f.lifecycle.requestedAt);
    useCase = BookAppointmentUseCase(repository, clock);
  });

  test('valid request returns the repository appointment', () async {
    final result = await useCase(request());
    expect(result.isSuccess, isTrue);
    expect(result.data, f.lifecycle.request());
  });

  test(
    'transaction slots return the first overlap violation in rule order',
    () async {
      repository.staffSlots = [f.slot(id: 'staff-conflict')];
      repository.patientSlots = [f.slot(id: 'patient-conflict')];
      final result = await useCase(request());
      expect(result.errorCode, AppointmentErrorCode.staffOverlap);
      expect(repository.current, isNull);
    },
  );

  test('transaction retry reads the clock and slots again', () async {
    await useCase(request());
    when(clock.now).thenReturn(f.at('2026-11-01', '11:00'));
    final violations = repository.check?.call([f.slot(id: 'new')], []);
    expect(violations?.map((v) => v.code), [
      AppointmentErrorCode.inPast,
      AppointmentErrorCode.staffOverlap,
    ]);
  });
}
