import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';
import 'package:clinic_appointment_system/features/availability/domain/errors/availability_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/models/availability_subject.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_window_save_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/support/availability_fixture.dart';
import 'doubles/controllable_window_request_cubit.dart';

void main() {
  const fixture = AvailabilityFixture();
  const subject = AvailabilitySubject(staffId: 'staff', branchId: 'branch');
  late ControllableWindowRequestCubit cubit;
  setUp(() {
    cubit = ControllableWindowRequestCubit()
      ..result = DataResult.success(data: fixture.empty);
    addTearDown(cubit.close);
  });

  test('submits the subject/window and emits saving, saved, reset', () async {
    final window = fixture.weekly(540, 600);
    expect(cubit.state, const AvailabilityWindowSaveInitial());
    final emissions = expectLater(
      cubit.stream,
      emitsInOrder([
        const AvailabilityWindowSaving(),
        AvailabilityWindowSaved(fixture.empty),
        const AvailabilityWindowSaveInitial(),
      ]),
    );
    await cubit.submit(subject, window);
    expect(cubit.requests.single.subject, subject);
    expect(cubit.requests.single.window, window);
    cubit.reset();
    await emissions;
  });

  test('domain failures retain their code and conflicting window', () async {
    final conflict = fixture.weekly(540, 600);
    cubit.error = AvailabilityException(
      AvailabilityErrorCode.overlappingWindow,
      conflict: conflict,
    );
    await cubit.submit(subject, fixture.weekly(570, 630));
    expect(
      cubit.state,
      AvailabilityWindowSaveFailure(
        AvailabilityErrorCode.overlappingWindow,
        conflict: conflict,
      ),
    );
  });

  test('unexpected exceptions and errors become unavailable', () async {
    for (final error in [Exception('provider'), StateError('provider')]) {
      cubit.error = error;
      await cubit.submit(subject, fixture.weekly(540, 600));
      expect(
        cubit.state,
        const AvailabilityWindowSaveFailure(AvailabilityErrorCode.unavailable),
      );
    }
  });

  test('non-success and missing data become unavailable', () async {
    for (final result in <DataResult<StaffAvailability>>[
      const DataResult.error(),
      const DataResult.success(data: null),
    ]) {
      cubit.result = result;
      await cubit.submit(subject, fixture.weekly(540, 600));
      expect(
        cubit.state,
        const AvailabilityWindowSaveFailure(AvailabilityErrorCode.unavailable),
      );
    }
  });

  test(
    'single-flight ignores repeated submission and reset until completion',
    () async {
      final gate = Completer<void>();
      cubit.gate = gate;
      final pending = cubit.submit(subject, fixture.weekly(540, 600));
      await cubit.submit(subject, fixture.weekly(600, 660));
      cubit.reset();
      expect(cubit.requests, hasLength(1));
      expect(cubit.state, const AvailabilityWindowSaving());
      gate.complete();
      await pending;
      expect(cubit.state, AvailabilityWindowSaved(fixture.empty));
    },
  );

  for (final failure in <Object?>[
    null,
    const AvailabilityException(AvailabilityErrorCode.windowNotFound),
    StateError('late'),
  ]) {
    test('completion after close is ignored: $failure', () async {
      cubit.gate = Completer<void>();
      cubit.error = failure;
      final states = <AvailabilityWindowSaveState>[];
      final subscription = cubit.stream.listen(states.add);
      final pending = cubit.submit(subject, fixture.weekly(540, 600));
      await cubit.close();
      cubit.gate?.complete();
      await pending;
      await subscription.cancel();
      expect(states, [const AvailabilityWindowSaving()]);
      await cubit.submit(subject, fixture.weekly(600, 660));
      cubit.reset();
      expect(cubit.requests, hasLength(1));
      expect(cubit.state, const AvailabilityWindowSaving());
    });
  }
}
