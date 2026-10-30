import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/examination_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/lab_test_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model_factory.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/radiology_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

void main() {
  const factory = MedicalServiceModelFactory();

  group('Round trip per kind', () {
    test('examination entity serializes and deserializes correctly', () {
      final entity = Examination(
        id: 'exam-1',
        name: 'General Consultation',
        departmentId: 'dept-1',
        branchId: 'branch-1',
        duration: ServiceDuration(30),
        fee: Money.kurus(75000),
      );

      final model = factory.toModel(entity);
      final json = model.toJson();

      expect(json, {
        'name': 'General Consultation',
        'departmentId': 'dept-1',
        'branchId': 'branch-1',
        'kind': 'examination',
        'durationMinutes': 30,
        'feeKurus': 75000,
      });
      expect(json.containsKey('id'), isFalse);

      final restored = factory.fromJson({...json, 'id': 'exam-1'});
      expect(restored, isA<ExaminationModel>());
      expect(restored.id, 'exam-1');
      expect(restored.name, entity.name);
      expect(restored.departmentId, entity.departmentId);
      expect(restored.branchId, entity.branchId);
      expect(restored.duration, entity.duration);
      expect(restored.fee, entity.fee);
      expect(restored.kind, MedicalServiceKind.examination);
    });

    test('radiology entity with preparationNote round trips correctly', () {
      final entity = RadiologyService(
        id: 'rad-1',
        name: 'Abdominal Ultrasound',
        departmentId: 'dept-1',
        branchId: 'branch-1',
        duration: ServiceDuration(20),
        fee: Money.kurus(120000),
        modality: RadiologyModality.ultrasound,
        preparationNote: 'Drink 1 liter of water beforehand.',
      );

      final model = factory.toModel(entity);
      final json = model.toJson();

      expect(json, {
        'name': 'Abdominal Ultrasound',
        'departmentId': 'dept-1',
        'branchId': 'branch-1',
        'kind': 'radiology',
        'durationMinutes': 20,
        'feeKurus': 120000,
        'modality': 'ultrasound',
        'preparationNote': 'Drink 1 liter of water beforehand.',
      });
      expect(json.containsKey('id'), isFalse);

      final restored = factory.fromJson({...json, 'id': 'rad-1'});
      expect(restored, isA<RadiologyServiceModel>());
      expect(restored.id, 'rad-1');
      expect(restored.name, entity.name);
      expect(restored.departmentId, entity.departmentId);
      expect(restored.branchId, entity.branchId);
      expect(restored.duration, entity.duration);
      expect(restored.fee, entity.fee);
      expect(
        (restored as RadiologyServiceModel).modality,
        RadiologyModality.ultrasound,
      );
      expect(restored.preparationNote, 'Drink 1 liter of water beforehand.');
      expect(restored.kind, MedicalServiceKind.radiology);
    });

    test('radiology entity without preparationNote omits key from json', () {
      final entity = RadiologyService(
        id: 'rad-2',
        name: 'Brain MRI',
        departmentId: 'dept-1',
        branchId: 'branch-1',
        duration: ServiceDuration(45),
        fee: Money.kurus(350000),
        modality: RadiologyModality.mri,
        preparationNote: null,
      );

      final model = factory.toModel(entity);
      final json = model.toJson();

      expect(json, {
        'name': 'Brain MRI',
        'departmentId': 'dept-1',
        'branchId': 'branch-1',
        'kind': 'radiology',
        'durationMinutes': 45,
        'feeKurus': 350000,
        'modality': 'mri',
      });
      expect(json.containsKey('id'), isFalse);
      expect(json.containsKey('preparationNote'), isFalse);

      final restored = factory.fromJson({...json, 'id': 'rad-2'});
      expect(restored, isA<RadiologyServiceModel>());
      expect((restored as RadiologyServiceModel).preparationNote, isNull);
    });

    test('lab test entity with fasting hours round trips correctly', () {
      final entity = LabTest(
        id: 'lab-1',
        name: 'Lipid Panel',
        departmentId: 'dept-1',
        branchId: 'branch-1',
        duration: ServiceDuration(15),
        fee: Money.kurus(45000),
        resultTime: LabResultTime.oneDay,
        fastingHours: FastingHours(min: 10, max: 12),
      );

      final model = factory.toModel(entity);
      final json = model.toJson();

      expect(json, {
        'name': 'Lipid Panel',
        'departmentId': 'dept-1',
        'branchId': 'branch-1',
        'kind': 'lab',
        'durationMinutes': 15,
        'feeKurus': 45000,
        'resultTime': 'oneDay',
        'fastingHours': {'min': 10, 'max': 12},
        'requiresFasting': true,
      });
      expect(json.containsKey('id'), isFalse);

      final restored = factory.fromJson({...json, 'id': 'lab-1'});
      expect(restored, isA<LabTestModel>());
      expect(restored.id, 'lab-1');
      expect(restored.name, entity.name);
      expect(restored.departmentId, entity.departmentId);
      expect(restored.branchId, entity.branchId);
      expect(restored.duration, entity.duration);
      expect(restored.fee, entity.fee);
      expect((restored as LabTestModel).resultTime, LabResultTime.oneDay);
      expect(restored.fastingHours, FastingHours(min: 10, max: 12));
      expect(restored.requiresFasting, isTrue);
      expect(restored.kind, MedicalServiceKind.lab);
    });

    test(
      'lab test entity without fasting omits fastingHours and writes requiresFasting false',
      () {
        final entity = LabTest(
          id: 'lab-2',
          name: 'Complete Blood Count',
          departmentId: 'dept-1',
          branchId: 'branch-1',
          duration: ServiceDuration(10),
          fee: Money.kurus(20000),
          resultTime: LabResultTime.sameDay,
          fastingHours: null,
        );

        final model = factory.toModel(entity);
        final json = model.toJson();

        expect(json, {
          'name': 'Complete Blood Count',
          'departmentId': 'dept-1',
          'branchId': 'branch-1',
          'kind': 'lab',
          'durationMinutes': 10,
          'feeKurus': 20000,
          'resultTime': 'sameDay',
          'requiresFasting': false,
        });
        expect(json.containsKey('id'), isFalse);
        expect(json.containsKey('fastingHours'), isFalse);
        expect(json['requiresFasting'], isFalse);

        final restored = factory.fromJson({...json, 'id': 'lab-2'});
        expect(restored, isA<LabTestModel>());
        expect((restored as LabTestModel).fastingHours, isNull);
        expect(restored.requiresFasting, isFalse);
      },
    );
  });

  group('Factory validation and rejection', () {
    test('throws ArgumentError for unknown kind', () {
      expect(
        () => factory.fromJson({'kind': 'surgery', 'id': 's1'}),
        throwsArgumentError,
      );
    });

    test('throws TypeError for missing kind', () {
      expect(() => factory.fromJson({'id': 's1'}), throwsA(isA<TypeError>()));
    });

    test('throws TypeError for non-string kind', () {
      expect(
        () => factory.fromJson({'kind': 42, 'id': 's1'}),
        throwsA(isA<TypeError>()),
      );
    });

    test('throws CheckedFromJsonException for missing required fields', () {
      expect(
        () => factory.fromJson({
          'kind': 'examination',
          'id': 'exam-1',
          'branchId': 'branch-1',
          'durationMinutes': 20,
          'feeKurus': 50000,
        }),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test('throws CheckedFromJsonException for wrong field types', () {
      expect(
        () => factory.fromJson({
          'kind': 'examination',
          'id': 'exam-1',
          'name': 'Checkup',
          'departmentId': 'dept-1',
          'branchId': 'branch-1',
          'durationMinutes': '20',
          'feeKurus': 50000,
        }),
        throwsA(isA<CheckedFromJsonException>()),
      );
    });

    test(
      'throws CheckedFromJsonException wrapping InstitutionException for out-of-range duration',
      () {
        for (final duration in [4, 241]) {
          expect(
            () => factory.fromJson({
              'kind': 'examination',
              'id': 'exam-1',
              'name': 'Checkup',
              'departmentId': 'dept-1',
              'branchId': 'branch-1',
              'durationMinutes': duration,
              'feeKurus': 50000,
            }),
            throwsA(
              isA<CheckedFromJsonException>().having(
                (error) => error.innerError,
                'innerError',
                isA<InstitutionException>().having(
                  (error) => error.code,
                  'code',
                  InstitutionErrorCode.invalidDuration,
                ),
              ),
            ),
          );
        }
      },
    );

    test(
      'throws CheckedFromJsonException wrapping InstitutionException for out-of-range fee',
      () {
        for (final fee in [0, 10000001]) {
          expect(
            () => factory.fromJson({
              'kind': 'examination',
              'id': 'exam-1',
              'name': 'Checkup',
              'departmentId': 'dept-1',
              'branchId': 'branch-1',
              'durationMinutes': 30,
              'feeKurus': fee,
            }),
            throwsA(
              isA<CheckedFromJsonException>().having(
                (error) => error.innerError,
                'innerError',
                isA<InstitutionException>().having(
                  (error) => error.code,
                  'code',
                  InstitutionErrorCode.invalidFee,
                ),
              ),
            ),
          );
        }
      },
    );

    test(
      'throws CheckedFromJsonException wrapping ArgumentError for unknown modality',
      () {
        expect(
          () => factory.fromJson({
            'kind': 'radiology',
            'id': 'rad-1',
            'name': 'PET Scan',
            'departmentId': 'dept-1',
            'branchId': 'branch-1',
            'durationMinutes': 30,
            'feeKurus': 50000,
            'modality': 'pet',
          }),
          throwsA(
            isA<CheckedFromJsonException>().having(
              (error) => error.innerError,
              'innerError',
              isArgumentError,
            ),
          ),
        );
      },
    );

    test(
      'throws CheckedFromJsonException wrapping ArgumentError for unknown resultTime',
      () {
        expect(
          () => factory.fromJson({
            'kind': 'lab',
            'id': 'lab-1',
            'name': 'Blood Test',
            'departmentId': 'dept-1',
            'branchId': 'branch-1',
            'durationMinutes': 15,
            'feeKurus': 20000,
            'resultTime': 'inTwoWeeks',
            'requiresFasting': false,
          }),
          throwsA(
            isA<CheckedFromJsonException>().having(
              (error) => error.innerError,
              'innerError',
              isArgumentError,
            ),
          ),
        );
      },
    );

    test(
      'throws FormatException when fastingHours present while requiresFasting is false',
      () {
        expect(
          () => factory.fromJson({
            'kind': 'lab',
            'id': 'lab-1',
            'name': 'Blood Test',
            'departmentId': 'dept-1',
            'branchId': 'branch-1',
            'durationMinutes': 15,
            'feeKurus': 20000,
            'resultTime': 'sameDay',
            'requiresFasting': false,
            'fastingHours': {'min': 8, 'max': 12},
          }),
          throwsFormatException,
        );
      },
    );

    test(
      'throws FormatException when fastingHours absent while requiresFasting is true',
      () {
        expect(
          () => factory.fromJson({
            'kind': 'lab',
            'id': 'lab-1',
            'name': 'Blood Test',
            'departmentId': 'dept-1',
            'branchId': 'branch-1',
            'durationMinutes': 15,
            'feeKurus': 20000,
            'resultTime': 'sameDay',
            'requiresFasting': true,
          }),
          throwsFormatException,
        );
      },
    );

    test('throws FormatException when requiresFasting is not a boolean', () {
      expect(
        () => factory.fromJson({
          'kind': 'lab',
          'id': 'lab-1',
          'name': 'Blood Test',
          'departmentId': 'dept-1',
          'branchId': 'branch-1',
          'durationMinutes': 15,
          'feeKurus': 20000,
          'resultTime': 'sameDay',
          'requiresFasting': 'true',
          'fastingHours': {'min': 8, 'max': 12},
        }),
        throwsFormatException,
      );
    });

    test(
      'throws CheckedFromJsonException wrapping InstitutionException for inverted fastingHours {min: 12, max: 8}',
      () {
        expect(
          () => factory.fromJson({
            'kind': 'lab',
            'id': 'lab-1',
            'name': 'Blood Test',
            'departmentId': 'dept-1',
            'branchId': 'branch-1',
            'durationMinutes': 15,
            'feeKurus': 20000,
            'resultTime': 'sameDay',
            'requiresFasting': true,
            'fastingHours': {'min': 12, 'max': 8},
          }),
          throwsA(
            isA<CheckedFromJsonException>().having(
              (error) => error.innerError,
              'innerError',
              isA<InstitutionException>().having(
                (error) => error.code,
                'code',
                InstitutionErrorCode.invalidFastingHours,
              ),
            ),
          ),
        );
      },
    );
  });
}
