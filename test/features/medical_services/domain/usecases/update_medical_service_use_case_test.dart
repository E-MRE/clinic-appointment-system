import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/update_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_medical_service_repository.dart';

void main() {
  group('UpdateMedicalServiceUseCase', () {
    test('trims a valid service and forwards to repository', () async {
      final repository = FakeMedicalServiceRepository();
      final updated = Examination(
        id: 's-1',
        name: 'Follow-up',
        departmentId: 'dept-1',
        branchId: 'b-1',
        duration: ServiceDuration(20),
        fee: Money.kurus(4000),
      );
      final result = DataResult<MedicalService>.success(data: updated);
      repository.updateResult = result;

      final useCase = UpdateMedicalServiceUseCase(repository);
      final response = await useCase(
        Examination(
          id: 's-1',
          name: '  Follow-up  ',
          departmentId: '  dept-1  ',
          branchId: '  b-1  ',
          duration: ServiceDuration(20),
          fee: Money.kurus(4000),
        ),
      );

      expect(response, same(result));
      expect(repository.updateCalls, 1);
      expect(repository.updatedService?.name, 'Follow-up');
      expect(repository.updatedService?.departmentId, 'dept-1');
      expect(repository.updatedService?.branchId, 'b-1');
    });

    test('rejects a blank name without calling repository', () async {
      final repository = FakeMedicalServiceRepository();
      final useCase = UpdateMedicalServiceUseCase(repository);

      await expectLater(
        useCase(
          Examination(
            id: 's-1',
            name: '   ',
            departmentId: 'dept-1',
            branchId: 'b-1',
            duration: ServiceDuration(20),
            fee: Money.kurus(4000),
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
      expect(repository.updateCalls, 0);
    });

    test('rejects a blank department without calling repository', () async {
      final repository = FakeMedicalServiceRepository();
      final useCase = UpdateMedicalServiceUseCase(repository);

      await expectLater(
        useCase(
          Examination(
            id: 's-1',
            name: 'Follow-up',
            departmentId: '   ',
            branchId: 'b-1',
            duration: ServiceDuration(20),
            fee: Money.kurus(4000),
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
      expect(repository.updateCalls, 0);
    });

    test(
      'rejects 201-character preparation note without calling repository',
      () async {
        final repository = FakeMedicalServiceRepository();
        final useCase = UpdateMedicalServiceUseCase(repository);

        await expectLater(
          useCase(
            RadiologyService(
              id: 'r-1',
              name: 'Ultrasound',
              departmentId: 'dept-2',
              branchId: 'b-1',
              duration: ServiceDuration(30),
              fee: Money.kurus(80000),
              modality: RadiologyModality.ultrasound,
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
        expect(repository.updateCalls, 0);
      },
    );

    test('propagates repository exceptions', () async {
      final repository = FakeMedicalServiceRepository();
      const exception = InstitutionException(InstitutionErrorCode.unavailable);
      repository.updateException = exception;

      final useCase = UpdateMedicalServiceUseCase(repository);
      await expectLater(
        useCase(
          Examination(
            id: 's-1',
            name: 'Follow-up',
            departmentId: 'dept-1',
            branchId: 'b-1',
            duration: ServiceDuration(20),
            fee: Money.kurus(4000),
          ),
        ),
        throwsA(same(exception)),
      );
      expect(repository.updateCalls, 1);
    });
  });
}
