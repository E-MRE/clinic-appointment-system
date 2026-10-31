import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/domain/rules/availability_policy.dart';
import 'package:clinic_appointment_system/features/availability/domain/usecases/add_availability_window_use_case.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_add_cubit.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_save_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../domain/doubles/fake_staff_availability_repository.dart';
import '../../domain/support/availability_fixture.dart';
import '../doubles/mock_branch_repository.dart';

void main() {
  const fixture = AvailabilityFixture();
  const subject = AvailabilitySubject(staffId: 'staff', branchId: 'branch');
  late FakeStaffAvailabilityRepository repository;
  late MockBranchRepository branches;
  late AvailabilityWindowAddCubit cubit;

  setUp(() {
    repository = FakeStaffAvailabilityRepository(fixture.empty);
    branches = MockBranchRepository();
    when(() => branches.watchBranch(subject.branchId)).thenAnswer(
      (_) => Stream.value(
        DataResult.success(
          data: Branch(
            id: subject.branchId,
            name: 'Central',
            clinicId: 'clinic',
            address: 'Main street',
            workingHours: fixture.hours,
          ),
        ),
      ),
    );
    final clock = FixedClock(DateTime(2026, 11, 2));
    cubit = AvailabilityWindowAddCubit(
      AddAvailabilityWindowUseCase(
        repository,
        branches,
        clock,
        const AvailabilityPolicy.standard(),
      ),
    );
    addTearDown(cubit.close);
  });

  test('add emits saving then saved and reset restores initial', () async {
    final window = fixture.weekly(540, 600);
    final saved = fixture.empty.adding(window);
    expect(cubit.state, const AvailabilityWindowSaveInitial());
    final emissions = expectLater(
      cubit.stream,
      emitsInOrder([
        const AvailabilityWindowSaving(),
        AvailabilityWindowSaved(saved),
      ]),
    );
    await cubit.submit(subject, window);
    await emissions;
    expect(cubit.state, AvailabilityWindowSaved(saved));
    cubit.reset();
    expect(cubit.state, const AvailabilityWindowSaveInitial());
  });

  test('overlap failure preserves the conflicting window', () async {
    final conflict = fixture.weekly(540, 600);
    repository.current = fixture.empty.adding(conflict);
    await cubit.submit(subject, fixture.weekly(570, 630));
    expect(
      cubit.state,
      AvailabilityWindowSaveFailure(
        AvailabilityErrorCode.overlappingWindow,
        conflict: conflict,
      ),
    );
    expect(repository.writes, isZero);
  });

  test('unexpected exceptions and errors map to unavailable', () async {
    for (final error in [Exception('provider'), StateError('provider')]) {
      repository.updateError = error;
      await cubit.submit(subject, fixture.weekly(540, 600));
      expect(
        cubit.state,
        const AvailabilityWindowSaveFailure(AvailabilityErrorCode.unavailable),
      );
    }
  });

  test('non-success and null data map to unavailable', () async {
    for (final result in <DataResult<StaffAvailability>>[
      const DataResult.error(),
      const DataResult.success(data: null),
    ]) {
      repository.updateResult = result;
      await cubit.submit(subject, fixture.weekly(540, 600));
      expect(
        cubit.state,
        const AvailabilityWindowSaveFailure(AvailabilityErrorCode.unavailable),
      );
    }
  });

  test('second add and reset while saving are ignored', () async {
    final gate = Completer<void>();
    repository.updateGate = gate.future;
    final window = fixture.weekly(540, 600);
    final pending = cubit.submit(subject, window);
    await Future<void>.delayed(Duration.zero);
    await cubit.submit(subject, window);
    cubit.reset();
    expect(cubit.state, const AvailabilityWindowSaving());
    const expectedCalls = 1;
    verify(() => branches.watchBranch(subject.branchId)).called(expectedCalls);
    expect(repository.updateCalls, expectedCalls);
    gate.complete();
    await pending;
    expect(cubit.state, AvailabilityWindowSaved(fixture.empty.adding(window)));
  });

  test('late add success after close emits nothing', () async {
    final gate = Completer<void>();
    repository.updateGate = gate.future;
    final states = <AvailabilityWindowSaveState>[];
    final subscription = cubit.stream.listen(states.add);
    final pending = cubit.submit(subject, fixture.weekly(540, 600));
    await Future<void>.delayed(Duration.zero);
    await cubit.close();
    gate.complete();
    await pending;
    await subscription.cancel();
    expect(states, [const AvailabilityWindowSaving()]);
    await cubit.submit(subject, fixture.weekly(600, 660));
    await cubit.submit(subject, fixture.weekly(540, 600));
    cubit.reset();
    const expectedCalls = 1;
    expect(repository.updateCalls, expectedCalls);
    expect(cubit.state, const AvailabilityWindowSaving());
  });
}
