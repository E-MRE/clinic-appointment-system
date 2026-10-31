import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/watch_staff_availability_use_case.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/staff_availability_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/fake_staff_availability_repository.dart';
import '../../domain/support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  const subject = AvailabilitySubject(staffId: 'staff', branchId: 'branch');
  late FakeStaffAvailabilityRepository repository;
  late StaffAvailabilityCubit cubit;

  setUp(() {
    repository = FakeStaffAvailabilityRepository(fixture.empty);
    cubit = StaffAvailabilityCubit(WatchStaffAvailabilityUseCase(repository));
    addTearDown(cubit.close);
  });

  test('watch maps loading and loaded schedule for its subject', () async {
    final availability = fixture.empty.adding(fixture.weekly(540, 600));
    repository.stream = Stream.value(DataResult.success(data: availability));
    expect(
      cubit.state,
      const WatchLoading<StaffAvailability, AvailabilityErrorCode>(),
    );
    await cubit.watch(subject);
    await Future<void>.delayed(Duration.zero);
    expect(repository.watchedSubject, subject);
    expect(
      cubit.state,
      WatchLoaded<StaffAvailability, AvailabilityErrorCode>(availability),
    );
  });

  test(
    'typed failure keeps its code; unexpected and failed results use unavailable',
    () async {
      final cases =
          <(Stream<DataResult<StaffAvailability>>, AvailabilityErrorCode)>[
            (
              Stream.error(
                const AvailabilityException(
                  AvailabilityErrorCode.invalidRecord,
                ),
              ),
              AvailabilityErrorCode.invalidRecord,
            ),
            (
              Stream.error(StateError('provider')),
              AvailabilityErrorCode.unavailable,
            ),
            (
              Stream.value(const DataResult.error()),
              AvailabilityErrorCode.unavailable,
            ),
            (
              Stream.value(const DataResult.success(data: null)),
              AvailabilityErrorCode.unavailable,
            ),
          ];
      for (final (stream, code) in cases) {
        repository.stream = stream;
        await cubit.watch(subject);
        await Future<void>.delayed(Duration.zero);
        expect(
          cubit.state,
          WatchFailure<StaffAvailability, AvailabilityErrorCode>(code),
        );
      }
    },
  );
}
