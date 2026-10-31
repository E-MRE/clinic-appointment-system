import 'dart:async';

import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/remove_availability_window_use_case.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_remove_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_save_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../domain/doubles/fake_staff_availability_repository.dart';
import '../../domain/support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  const subject = AvailabilitySubject(staffId: 'staff', branchId: 'branch');
  late FakeStaffAvailabilityRepository repository;
  late AvailabilityWindowRemoveCubit cubit;
  setUp(() {
    repository = FakeStaffAvailabilityRepository(fixture.empty);
    cubit = AvailabilityWindowRemoveCubit(
      RemoveAvailabilityWindowUseCase(
        repository,
        FixedClock(DateTime(2026, 11, 2)),
      ),
    );
    addTearDown(cubit.close);
  });

  test('remove saves a present window and reports an absent window', () async {
    final window = fixture.weekly(540, 600);
    repository.current = fixture.empty.adding(window);
    await cubit.submit(subject, window);
    expect(cubit.state, AvailabilityWindowSaved(fixture.empty));
    await cubit.submit(subject, window);
    expect(
      cubit.state,
      const AvailabilityWindowSaveFailure(AvailabilityErrorCode.windowNotFound),
    );
  });

  test(
    'late domain and unexpected remove failures after close emit nothing',
    () async {
      for (final error in <Object>[
        const AvailabilityException(AvailabilityErrorCode.windowNotFound),
        StateError('late'),
      ]) {
        final delayedRepository = FakeStaffAvailabilityRepository(
          fixture.empty,
        );
        final gate = Completer<void>();
        delayedRepository.updateGate = gate.future;
        delayedRepository.updateError = error;
        final lateCubit = AvailabilityWindowRemoveCubit(
          RemoveAvailabilityWindowUseCase(
            delayedRepository,
            FixedClock(DateTime(2026, 11, 2)),
          ),
        );
        final states = <AvailabilityWindowSaveState>[];
        final subscription = lateCubit.stream.listen(states.add);
        final pending = lateCubit.submit(subject, fixture.weekly(540, 600));
        await lateCubit.close();
        gate.complete();
        await pending;
        await subscription.cancel();
        expect(states, [const AvailabilityWindowSaving()]);
        expect(lateCubit.state, const AvailabilityWindowSaving());
      }
    },
  );
}
