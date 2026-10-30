import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_state.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/create_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/update_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_save_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../domain/doubles/fake_medical_service_repository.dart';

void main() {
  group('MedicalServiceSaveCubit', () {
    late FakeMedicalServiceRepository repository;
    late MedicalServiceSaveCubit cubit;

    setUp(() {
      repository = FakeMedicalServiceRepository();
      cubit = MedicalServiceSaveCubit(
        CreateMedicalServiceUseCase(repository),
        UpdateMedicalServiceUseCase(repository),
      );
    });

    tearDown(() => cubit.close());

    test('creates and updates a service through saved states', () async {
      final sample = _sampleService(name: 'General Checkup');
      final created = _sampleService(id: 's-created', name: 'General Checkup');
      repository.createResult = DataResult.success(data: created);

      await cubit.create(sample);
      expect(
        cubit.state,
        isA<InstitutionSaveSaved<MedicalService>>().having(
          (state) => state.value,
          'value',
          created,
        ),
      );

      final updated = _sampleService(id: 's-created', name: 'Special Checkup');
      repository.updateResult = DataResult.success(data: updated);
      await cubit.update(updated);

      expect(repository.updatedService?.name, 'Special Checkup');
      expect(repository.updatedService?.id, 's-created');
      expect(
        cubit.state,
        isA<InstitutionSaveSaved<MedicalService>>().having(
          (state) => state.value,
          'value',
          updated,
        ),
      );
    });

    test('validation failure code (blank name -> nameRequired)', () async {
      final invalid = _sampleService(name: '   ');
      await cubit.create(invalid);

      expect(repository.createCalls, 0);
      expect(
        cubit.state,
        isA<InstitutionSaveFailure<MedicalService>>().having(
          (state) => state.code,
          'code',
          InstitutionErrorCode.nameRequired,
        ),
      );
    });

    test('unexpected exceptions map to unavailable', () async {
      repository.createException = Exception('unexpected');
      final sample = _sampleService(name: 'Valid Name');
      await cubit.create(sample);

      expect(
        cubit.state,
        isA<InstitutionSaveFailure<MedicalService>>().having(
          (state) => state.code,
          'code',
          InstitutionErrorCode.unavailable,
        ),
      );
    });

    test('double submit ignored while in flight', () async {
      final completer = Completer<DataResult<MedicalService>>();
      final slowRepository = _SlowMedicalServiceRepository(completer.future);
      final slowCubit = MedicalServiceSaveCubit(
        CreateMedicalServiceUseCase(slowRepository),
        UpdateMedicalServiceUseCase(slowRepository),
      );
      addTearDown(slowCubit.close);

      final sample = _sampleService(name: 'Valid Name');
      final firstCall = slowCubit.create(sample);
      final secondCall = slowCubit.create(sample);

      expect(slowRepository.createCalls, 1);
      expect(slowCubit.state, isA<InstitutionSaveSaving<MedicalService>>());

      final created = _sampleService(id: 's-done', name: 'Valid Name');
      completer.complete(DataResult.success(data: created));
      await Future.wait([firstCall, secondCall]);

      expect(slowRepository.createCalls, 1);
      expect(
        slowCubit.state,
        isA<InstitutionSaveSaved<MedicalService>>().having(
          (state) => state.value,
          'value',
          created,
        ),
      );
    });

    test('close during save drops late result', () async {
      final completer = Completer<DataResult<MedicalService>>();
      final slowRepository = _SlowMedicalServiceRepository(completer.future);
      final slowCubit = MedicalServiceSaveCubit(
        CreateMedicalServiceUseCase(slowRepository),
        UpdateMedicalServiceUseCase(slowRepository),
      );

      final sample = _sampleService(name: 'Valid Name');
      final pendingSave = slowCubit.create(sample);
      await slowCubit.close();

      final created = _sampleService(id: 's-late', name: 'Valid Name');
      completer.complete(DataResult.success(data: created));
      await pendingSave;

      expect(slowCubit.isClosed, isTrue);
      expect(slowCubit.state, isA<InstitutionSaveSaving<MedicalService>>());
    });

    group('save', () {
      test('creates new service when original is null', () async {
        const values = MedicalServiceFormValues(
          kind: MedicalServiceKind.examination,
          name: 'General Consultation',
          departmentId: 'dept-1',
          durationText: '20',
          feeText: '800',
        );
        final created = _sampleService(
          id: 's-new',
          name: 'General Consultation',
        );
        repository.createResult = DataResult.success(data: created);

        await cubit.save(values, branchId: 'branch-1', original: null);

        expect(repository.createCalls, 1);
        expect(repository.createdService?.id, MedicalService.unsavedId);
        expect(repository.createdService?.name, 'General Consultation');
        expect(repository.createdService?.branchId, 'branch-1');
        expect(
          cubit.state,
          isA<InstitutionSaveSaved<MedicalService>>().having(
            (s) => s.value.id,
            'id',
            's-new',
          ),
        );
      });

      test('updates existing service when original is provided', () async {
        final existing = _sampleService(id: 's-exist', name: 'Old Name');
        const values = MedicalServiceFormValues(
          kind: MedicalServiceKind.examination,
          name: 'Updated Name',
          departmentId: 'dept-1',
          durationText: '30',
          feeText: '1000',
        );
        final updated = _sampleService(id: 's-exist', name: 'Updated Name');
        repository.updateResult = DataResult.success(data: updated);

        await cubit.save(values, branchId: 'branch-1', original: existing);

        expect(repository.updateCalls, 1);
        expect(repository.updatedService?.id, 's-exist');
        expect(repository.updatedService?.name, 'Updated Name');
        expect(
          cubit.state,
          isA<InstitutionSaveSaved<MedicalService>>().having(
            (s) => s.value.name,
            'name',
            'Updated Name',
          ),
        );
      });

      test(
        'parsing failure surfaces as domain failure code without calling use case',
        () async {
          const invalidValues = MedicalServiceFormValues(
            kind: MedicalServiceKind.examination,
            name: 'Checkup',
            departmentId: 'dept-1',
            durationText: '4',
            feeText: '500',
          );

          await cubit.save(invalidValues, branchId: 'branch-1');

          expect(repository.createCalls, 0);
          expect(
            cubit.state,
            isA<InstitutionSaveFailure<MedicalService>>().having(
              (s) => s.code,
              'code',
              InstitutionErrorCode.invalidDuration,
            ),
          );
        },
      );

      test('double submit ignored while in flight', () async {
        final completer = Completer<DataResult<MedicalService>>();
        final slowRepository = _SlowMedicalServiceRepository(completer.future);
        final slowCubit = MedicalServiceSaveCubit(
          CreateMedicalServiceUseCase(slowRepository),
          UpdateMedicalServiceUseCase(slowRepository),
        );
        addTearDown(slowCubit.close);

        const values = MedicalServiceFormValues(
          kind: MedicalServiceKind.examination,
          name: 'Valid Name',
          departmentId: 'dept-1',
          durationText: '20',
          feeText: '500',
        );

        final firstCall = slowCubit.save(values, branchId: 'branch-1');
        final secondCall = slowCubit.save(values, branchId: 'branch-1');

        expect(slowRepository.createCalls, 1);
        expect(slowCubit.state, isA<InstitutionSaveSaving<MedicalService>>());

        final created = _sampleService(id: 's-done', name: 'Valid Name');
        completer.complete(DataResult.success(data: created));
        await Future.wait([firstCall, secondCall]);

        expect(slowRepository.createCalls, 1);
        expect(slowCubit.state, isA<InstitutionSaveSaved<MedicalService>>());
      });
    });
  });
}

MedicalService _sampleService({
  String id = MedicalService.unsavedId,
  String name = 'Checkup',
}) {
  return Examination(
    id: id,
    name: name,
    departmentId: 'dept-1',
    branchId: 'branch-1',
    duration: ServiceDuration(30),
    fee: Money.minorUnits(50000),
  );
}

final class _SlowMedicalServiceRepository implements MedicalServiceRepository {
  _SlowMedicalServiceRepository(this._delayedResult);

  final Future<DataResult<MedicalService>> _delayedResult;
  int createCalls = 0;
  MedicalService? createdService;

  @override
  Stream<DataResult<List<MedicalService>>> watchServices(String branchId) =>
      const Stream.empty();

  @override
  Future<DataResult<MedicalService>> createService(MedicalService service) {
    createCalls++;
    createdService = service;
    return _delayedResult;
  }

  @override
  Future<DataResult<MedicalService>> updateService(MedicalService service) =>
      _delayedResult;
}
