import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_staff_repository.dart';
import '../doubles/staff_fixtures.dart';

void main() {
  test('observes all staff changes and preserves stream errors', () async {
    const StaffFixtures fixtures = StaffFixtures();
    final FakeStaffRepository repository = FakeStaffRepository();
    final DataResult<List<Staff>> first = DataResult.success(
      data: [fixtures.doctor(), fixtures.technician()],
    );
    const DataResult<List<Staff>> empty = DataResult.success(data: []);
    const UserException error = UserException(UserErrorCode.unavailable);
    repository.staffStream = Stream<DataResult<List<Staff>>>.multi((
      controller,
    ) {
      controller.add(first);
      controller.addError(error);
      controller.add(empty);
      controller.close();
    });
    await expectLater(
      WatchStaffUseCase(repository)(const NoParams()),
      emitsInOrder([
        same(first),
        emitsError(same(error)),
        same(empty),
        emitsDone,
      ]),
    );
  });

  test('propagates synchronous stream setup failures', () {
    final FakeStaffRepository repository = FakeStaffRepository();
    const UserException error = UserException(UserErrorCode.unavailable);
    repository.watchException = error;
    expect(
      () => WatchStaffUseCase(repository)(const NoParams()),
      throwsA(same(error)),
    );
  });
}
