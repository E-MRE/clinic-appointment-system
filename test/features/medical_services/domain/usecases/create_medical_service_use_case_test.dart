import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/create_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_medical_service_repository.dart';

void main() {
  group('CreateMedicalServiceUseCase', () {
    test('trims a valid service and forwards to repository', () async {
      final repository = FakeMedicalServiceRepository();
      final created = Examination(
        id: 's-1',
        name: 'Checkup',
        departmentId: 'dept-1',
        branchId: 'b-1',
        duration: ServiceDuration(30),
        fee: Money.minorUnits(5000),
      );
      final result = DataResult<MedicalService>.success(data: created);
      repository.createResult = result;

      final useCase = CreateMedicalServiceUseCase(repository);
      final response = await useCase(
        Examination(
          id: MedicalService.unsavedId,
          name: '  Checkup  ',
          departmentId: '  dept-1  ',
          branchId: '  b-1  ',
          duration: ServiceDuration(30),
          fee: Money.minorUnits(5000),
        ),
      );

      expect(response, same(result));
      expect(repository.createCalls, 1);
      expect(repository.createdService?.name, 'Checkup');
      expect(repository.createdService?.departmentId, 'dept-1');
      expect(repository.createdService?.branchId, 'b-1');
    });

    test('rejects a blank name without calling repository', () async {
      final repository = FakeMedicalServiceRepository();
      final useCase = CreateMedicalServiceUseCase(repository);

      await expectLater(
        useCase(
          Examination(
            id: MedicalService.unsavedId,
            name: '   ',
            departmentId: 'dept-1',
            branchId: 'b-1',
            duration: ServiceDuration(30),
            fee: Money.minorUnits(5000),
          ),
        ),
        throwsA(
          isA<InstitutionException>().having(
            (error) => error.code,
            'code',
            InstitutionErrorCode.nameRequired,
          ),
        ),
      );
      expect(repository.createCalls, 0);
    });

    test('rejects a blank department without calling repository', () async {
      final repository = FakeMedicalServiceRepository();
      final useCase = CreateMedicalServiceUseCase(repository);

      await expectLater(
        useCase(
          Examination(
            id: MedicalService.unsavedId,
            name: 'Checkup',
            departmentId: '   ',
            branchId: 'b-1',
            duration: ServiceDuration(30),
            fee: Money.minorUnits(5000),
          ),
        ),
        throwsA(
          isA<InstitutionException>().having(
            (error) => error.code,
            'code',
            InstitutionErrorCode.departmentRequired,
          ),
        ),
      );
      expect(repository.createCalls, 0);
    });

    test(
      'rejects 201-character preparation note without calling repository',
      () async {
        final repository = FakeMedicalServiceRepository();
        final useCase = CreateMedicalServiceUseCase(repository);

        await expectLater(
          useCase(
            RadiologyService(
              id: MedicalService.unsavedId,
              name: 'MRI',
              departmentId: 'dept-1',
              branchId: 'b-1',
              duration: ServiceDuration(30),
              fee: Money.minorUnits(100000),
              modality: RadiologyModality.mri,
              preparationNote: 'x' * 201,
            ),
          ),
          throwsA(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.preparationNoteTooLong,
            ),
          ),
        );
        expect(repository.createCalls, 0);
      },
    );

    test('propagates repository exceptions', () async {
      final repository = FakeMedicalServiceRepository();
      const exception = InstitutionException(InstitutionErrorCode.unavailable);
      repository.createException = exception;

      final useCase = CreateMedicalServiceUseCase(repository);
      await expectLater(
        useCase(
          Examination(
            id: MedicalService.unsavedId,
            name: 'Checkup',
            departmentId: 'dept-1',
            branchId: 'b-1',
            duration: ServiceDuration(30),
            fee: Money.minorUnits(5000),
          ),
        ),
        throwsA(same(exception)),
      );
      expect(repository.createCalls, 1);
    });
  });
}
