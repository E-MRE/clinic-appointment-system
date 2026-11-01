import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'support/late_watch_stream.dart';
import 'support/mock_watch_use_case.dart';
import 'support/test_stream_watch_cubit.dart';

void main() {
  late MockWatchUseCase useCase;
  late TestStreamWatchCubit cubit;

  setUp(() {
    useCase = MockWatchUseCase();
    cubit = TestStreamWatchCubit(useCase);
    addTearDown(cubit.close);
  });

  test('re-watch drops callbacks from the old generation', () async {
    final old = LateWatchStream();
    final current = LateWatchStream();
    addTearDown(old.close);
    addTearDown(current.close);
    when(() => useCase('old')).thenAnswer((_) => old);
    when(() => useCase('current')).thenAnswer((_) => current);
    await cubit.watch('old');
    await cubit.watch('current');
    current.deliver('current');
    old.deliver('stale');
    expect(old.cancelled, isTrue);
    expect(cubit.state, 'loaded:current');
  });

  test('retry re-subscribes to the last parameters', () async {
    when(
      () => useCase('branch'),
    ).thenAnswer((_) => Stream.value(const DataResult.success(data: 'fresh')));
    await cubit.watch('branch');
    await Future<void>.delayed(Duration.zero);
    await cubit.retry();
    await Future<void>.delayed(Duration.zero);
    const expectedWatches = 2;
    verify(() => useCase('branch')).called(expectedWatches);
    expect(cubit.state, 'loaded:fresh');
  });

  test('retry before watch does nothing', () async {
    await cubit.retry();
    verifyNever(() => useCase(any()));
    expect(cubit.state, 'loading');
  });

  test('clear ignores old callbacks and forgets retry parameters', () async {
    final old = LateWatchStream();
    addTearDown(old.close);
    when(() => useCase('old')).thenAnswer((_) => old);
    await cubit.watch('old');
    old.deliver('old');
    await cubit.clear();
    old.deliver('late');
    await cubit.retry();
    const expectedWatches = 1;
    verify(() => useCase('old')).called(expectedWatches);
    expect(old.cancelled, isTrue);
    expect(cubit.state, 'loading');
  });

  test(
    'close cancels and ignores callbacks during and after cancellation',
    () async {
      final gate = Completer<void>();
      final old = LateWatchStream(onCancel: () => gate.future);
      addTearDown(old.close);
      when(() => useCase('old')).thenAnswer((_) => old);
      await cubit.watch('old');
      old.deliver('before');
      final closing = cubit.close();
      old.deliver('during');
      await cubit.watch('ignored');
      await cubit.retry();
      await cubit.clear();
      gate.complete();
      await closing;
      old.deliver('after');
      expect(old.cancelled, isTrue);
      expect(cubit.state, 'loaded:before');
      verifyNever(() => useCase('ignored'));
    },
  );

  test('synchronous setup exception becomes failure', () async {
    final error = Exception('setup');
    when(() => useCase('branch')).thenThrow(error);
    await cubit.watch('branch');
    expect(cubit.state, 'failure:$error');
  });

  test('stream error becomes failure', () async {
    final error = StateError('stream');
    when(() => useCase('branch')).thenAnswer((_) => Stream.error(error));
    await cubit.watch('branch');
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, 'failure:$error');
  });

  test('non-success and null data pass null to the failure hook', () async {
    for (final result in <DataResult<String>>[
      const DataResult.error(data: 'ignored'),
      const DataResult.success(data: null),
    ]) {
      when(() => useCase('branch')).thenAnswer((_) => Stream.value(result));
      await cubit.watch('branch');
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, 'failure:null');
    }
  });
}
