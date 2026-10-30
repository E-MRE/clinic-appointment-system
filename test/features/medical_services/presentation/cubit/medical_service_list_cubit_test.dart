import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('MedicalServiceListCubit', () {
    test('transitions from loading to loaded', () async {
      final repository = _MockMedicalServiceRepository();
      final controller =
          StreamController<DataResult<List<MedicalService>>>.broadcast();
      when(
        () => repository.watchServices('branch-1'),
      ).thenAnswer((_) => controller.stream);
      final cubit = MedicalServiceListCubit(
        WatchMedicalServicesUseCase(repository),
      );

      expect(cubit.state, isA<InstitutionListLoading<MedicalService>>());
      await cubit.watch('branch-1');

      final sampleService = _createSampleService(id: 's-1');
      controller.add(DataResult.success(data: [sampleService]));
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        isA<InstitutionListLoaded<MedicalService>>().having(
          (state) => state.items,
          'items',
          [sampleService],
        ),
      );
      await cubit.close();
      await controller.close();
    });

    test('watch uses requested branch and maps domain errors', () async {
      final repository = _MockMedicalServiceRepository();
      final controller =
          StreamController<DataResult<List<MedicalService>>>.broadcast();
      when(
        () => repository.watchServices('branch-1'),
      ).thenAnswer((_) => controller.stream);
      final cubit = MedicalServiceListCubit(
        WatchMedicalServicesUseCase(repository),
      );

      await cubit.watch('branch-1');
      controller.addError(
        const InstitutionException(InstitutionErrorCode.invalidRecord),
      );
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        isA<InstitutionListFailure<MedicalService>>().having(
          (state) => state.code,
          'code',
          InstitutionErrorCode.invalidRecord,
        ),
      );
      await cubit.close();
      await controller.close();
    });

    test('stream errors without a domain code use unavailable', () async {
      final repository = _MockMedicalServiceRepository();
      final controller =
          StreamController<DataResult<List<MedicalService>>>.broadcast();
      when(
        () => repository.watchServices('branch-1'),
      ).thenAnswer((_) => controller.stream);
      final cubit = MedicalServiceListCubit(
        WatchMedicalServicesUseCase(repository),
      );

      await cubit.watch('branch-1');
      controller.addError(StateError('unexpected error'));
      await Future<void>.delayed(Duration.zero);

      expect(
        cubit.state,
        isA<InstitutionListFailure<MedicalService>>().having(
          (state) => state.code,
          'code',
          InstitutionErrorCode.unavailable,
        ),
      );
      await cubit.close();
      await controller.close();
    });

    test(
      're-watch cancels old branch stream and observes the new branch',
      () async {
        bool firstCancelled = false;
        final first = StreamController<DataResult<List<MedicalService>>>(
          onCancel: () => firstCancelled = true,
        );
        final second = StreamController<DataResult<List<MedicalService>>>();
        final repository = _MockMedicalServiceRepository();
        when(() => repository.watchServices(any())).thenAnswer((invocation) {
          return switch (invocation.positionalArguments.single as String) {
            'branch-1' => first.stream,
            'branch-2' => second.stream,
            _ => const Stream.empty(),
          };
        });
        final cubit = MedicalServiceListCubit(
          WatchMedicalServicesUseCase(repository),
        );

        await cubit.watch('branch-1');
        await cubit.watch('branch-2');
        first.add(const DataResult.success(data: <MedicalService>[]));
        final service2 = _createSampleService(id: 's-2', branchId: 'branch-2');
        second.add(DataResult.success(data: [service2]));
        await Future<void>.delayed(Duration.zero);

        expect(firstCancelled, isTrue);
        expect(
          cubit.state,
          isA<InstitutionListLoaded<MedicalService>>().having(
            (state) => state.items.single.branchId,
            'branchId',
            'branch-2',
          ),
        );
        await cubit.close();
        await first.close();
        await second.close();
      },
    );

    test('retry restarts the observation', () async {
      int callCount = 0;
      final repository = _MockMedicalServiceRepository();
      when(() => repository.watchServices('branch-1')).thenAnswer((_) {
        callCount++;
        return const Stream.empty();
      });
      final cubit = MedicalServiceListCubit(
        WatchMedicalServicesUseCase(repository),
      );

      await cubit.watch('branch-1');
      expect(callCount, 1);

      await cubit.retry();
      expect(callCount, 2);

      await cubit.close();
    });

    test(
      'latest watch wins while an earlier cancellation is pending',
      () async {
        final cancelGate = Completer<void>();
        final first = StreamController<DataResult<List<MedicalService>>>(
          onCancel: () => cancelGate.future,
        );
        final second = StreamController<DataResult<List<MedicalService>>>();
        final third = StreamController<DataResult<List<MedicalService>>>();
        final repository = _MockMedicalServiceRepository();
        when(() => repository.watchServices(any())).thenAnswer((invocation) {
          return switch (invocation.positionalArguments.single as String) {
            'first' => first.stream,
            'second' => second.stream,
            'third' => third.stream,
            _ => const Stream.empty(),
          };
        });
        final cubit = MedicalServiceListCubit(
          WatchMedicalServicesUseCase(repository),
        );
        await cubit.watch('first');
        final pendingSecond = cubit.watch('second');
        final pendingThird = cubit.watch('third');
        cancelGate.complete();
        await Future.wait([pendingSecond, pendingThird]);
        final latest = _createSampleService(id: 's-latest', branchId: 'third');
        third.add(DataResult.success(data: [latest]));
        await Future<void>.delayed(Duration.zero);
        expect(
          cubit.state,
          isA<InstitutionListLoaded<MedicalService>>().having(
            (state) => state.items.single,
            'latest service',
            latest,
          ),
        );
        verifyNever(() => repository.watchServices('second'));
        await cubit.close();
        await first.close();
        unawaited(second.close());
        await third.close();
      },
    );

    test('close cancels a pending stream and ignores later events', () async {
      bool cancelled = false;
      final controller = StreamController<DataResult<List<MedicalService>>>(
        onCancel: () => cancelled = true,
      );
      final repository = _MockMedicalServiceRepository();
      when(
        () => repository.watchServices(any()),
      ).thenAnswer((_) => controller.stream);
      final cubit = MedicalServiceListCubit(
        WatchMedicalServicesUseCase(repository),
      );
      await cubit.watch('branch-1');
      final pending = cubit.close();

      await pending;
      controller.add(const DataResult.success(data: <MedicalService>[]));
      await Future<void>.delayed(Duration.zero);

      expect(cancelled, isTrue);
      expect(cubit.state, isA<InstitutionListLoading<MedicalService>>());
      await controller.close();
    });
  });
}

MedicalService _createSampleService({
  required String id,
  String branchId = 'branch-1',
}) {
  return Examination(
    id: id,
    name: 'General Checkup',
    departmentId: 'dept-1',
    branchId: branchId,
    duration: ServiceDuration(30),
    fee: Money.kurus(50000),
  );
}

class _MockMedicalServiceRepository extends Mock
    implements MedicalServiceRepository {}
