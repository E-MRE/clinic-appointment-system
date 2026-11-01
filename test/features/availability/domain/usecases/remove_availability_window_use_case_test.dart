import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_window_request.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/remove_availability_window_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../doubles/fake_staff_availability_repository.dart';
import '../support/availability_fixture.dart';
import '../support/availability_matchers.dart';

void main() {
  const fixture = AvailabilityFixture();
  const matchers = AvailabilityMatchers();
  const subject = AvailabilitySubject(staffId: 'staff', branchId: 'branch');
  late FakeStaffAvailabilityRepository repository;
  late RemoveAvailabilityWindowUseCase useCase;

  setUp(() {
    repository = FakeStaffAvailabilityRepository(fixture.empty);
    useCase = RemoveAvailabilityWindowUseCase(
      repository,
      FixedClock(DateTime(2026, 11, 2)),
    );
  });

  test('removes a present window and prunes expired one-offs', () async {
    final window = fixture.weekly(540, 600);
    final retained = fixture.oneOff(780, 840);
    final yesterday = CalendarDate(year: 2026, month: 11, day: 1);
    repository.current = fixture.empty
        .withOneOff([fixture.oneOff(540, 600, date: yesterday), retained])
        .adding(window);
    final result = await useCase(
      AvailabilityWindowRequest(subject: subject, window: window),
    );
    expect(result.isSuccess, isTrue);
    expect(result.data, fixture.empty.adding(retained));
    expect(repository.current, result.data);
    expect(repository.updatedSubject, subject);
  });

  test('absent window throws windowNotFound without writing', () async {
    await expectLater(
      useCase(
        AvailabilityWindowRequest(
          subject: subject,
          window: fixture.weekly(540, 600),
        ),
      ),
      matchers.throwsCode(AvailabilityErrorCode.windowNotFound),
    );
    expect(repository.writes, isZero);
  });
}
