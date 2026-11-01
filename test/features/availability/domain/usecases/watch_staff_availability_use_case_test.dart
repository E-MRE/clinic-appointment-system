import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_staff_availability_repository.dart';
import '../support/availability_fixture.dart';

void main() {
  test('delegates subject and preserves results and stream errors', () async {
    const fixture = AvailabilityFixture();
    const subject = AvailabilitySubject(staffId: 'staff', branchId: 'branch');
    final repository = FakeStaffAvailabilityRepository(fixture.empty);
    final success = DataResult.success(data: fixture.empty);
    const failure = DataResult<StaffAvailability>.error();
    const error = AvailabilityException(AvailabilityErrorCode.invalidRecord);
    repository.stream = Stream<DataResult<StaffAvailability>>.multi((
      controller,
    ) {
      controller.add(success);
      controller.addError(error);
      controller.add(failure);
      controller.close();
    });
    await expectLater(
      WatchStaffAvailabilityUseCase(repository)(subject),
      emitsInOrder([
        same(success),
        emitsError(same(error)),
        same(failure),
        emitsDone,
      ]),
    );
    expect(repository.watchedSubject, subject);
  });
}
