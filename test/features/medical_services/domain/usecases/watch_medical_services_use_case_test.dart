import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_medical_service_repository.dart';

void main() {
  group('WatchMedicalServicesUseCase', () {
    test('forwards branch id and repository stream items', () async {
      final repository = FakeMedicalServiceRepository();
      final controller = StreamController<DataResult<List<MedicalService>>>();
      repository.servicesStream = controller.stream;

      final useCase = WatchMedicalServicesUseCase(repository);
      final stream = useCase('b-123');

      expect(repository.watchedBranchId, 'b-123');

      final service = Examination(
        id: 's-1',
        name: 'Eye Exam',
        departmentId: 'dept-1',
        branchId: 'b-123',
        duration: ServiceDuration(25),
        fee: Money.kurus(60000),
      );
      final dataResult = DataResult<List<MedicalService>>.success(
        data: <MedicalService>[service],
      );

      final expectation = expectLater(
        stream,
        emitsInOrder(<dynamic>[
          dataResult,
          emitsError(
            isA<InstitutionException>().having(
              (error) => error.code,
              'code',
              InstitutionErrorCode.unavailable,
            ),
          ),
        ]),
      );

      controller.add(dataResult);
      controller.addError(
        const InstitutionException(InstitutionErrorCode.unavailable),
      );

      await expectation;
      await controller.close();
    });
  });
}
