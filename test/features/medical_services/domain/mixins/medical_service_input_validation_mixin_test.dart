import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/medical_service_validation_probe.dart';

void main() {
  group('MedicalServiceInputValidationMixin', () {
    final validation = MedicalServiceValidationProbe();

    test('departmentError requires non-blank department ID', () {
      expect(
        validation.departmentError(''),
        InstitutionErrorCode.departmentRequired,
      );
      expect(
        validation.departmentError('   '),
        InstitutionErrorCode.departmentRequired,
      );
      expect(validation.departmentError('dept-1'), isNull);
    });

    test(
      'durationInputError validates duration format and range without throwing',
      () {
        expect(validation.durationInputError('30'), isNull);
        expect(
          validation.durationInputError('0'),
          InstitutionErrorCode.invalidDuration,
        );
        expect(
          validation.durationInputError('abc'),
          InstitutionErrorCode.invalidDuration,
        );
      },
    );

    test('feeInputError validates lira input without throwing', () {
      expect(validation.feeInputError('150,50'), isNull);
      expect(validation.feeInputError('0'), InstitutionErrorCode.invalidFee);
      expect(
        validation.feeInputError('1.200'),
        InstitutionErrorCode.invalidFee,
      );
    });

    test('fastingInputError validates fasting string without throwing', () {
      expect(validation.fastingInputError('8-12'), isNull);
      expect(
        validation.fastingInputError('0'),
        InstitutionErrorCode.invalidFastingHours,
      );
      expect(
        validation.fastingInputError('12-8'),
        InstitutionErrorCode.invalidFastingHours,
      );
    });

    test('preparationNoteError enforces maximum length', () {
      final note200 = 'x' * 200;
      final note201 = 'x' * 201;

      expect(validation.preparationNoteError(note200), isNull);
      expect(
        validation.preparationNoteError(note201),
        InstitutionErrorCode.preparationNoteTooLong,
      );
      expect(validation.preparationNoteError('   $note200   '), isNull);
    });

    test('serviceError obeys first-error precedence', () {
      final bothInvalid = Examination(
        id: EntityConstants.unsavedId,
        name: '   ',
        departmentId: '   ',
        branchId: 'b1',
        duration: ServiceDuration(30),
        fee: Money.minorUnits(5000),
      );
      expect(
        validation.serviceError(bothInvalid),
        InstitutionErrorCode.nameRequired,
      );

      final departmentInvalid = Examination(
        id: EntityConstants.unsavedId,
        name: 'Consultation',
        departmentId: '   ',
        branchId: 'b1',
        duration: ServiceDuration(30),
        fee: Money.minorUnits(5000),
      );
      expect(
        validation.serviceError(departmentInvalid),
        InstitutionErrorCode.departmentRequired,
      );

      final detailsInvalid = RadiologyService(
        id: EntityConstants.unsavedId,
        name: 'MRI Scan',
        departmentId: 'dept-1',
        branchId: 'b1',
        duration: ServiceDuration(40),
        fee: Money.minorUnits(150000),
        modality: RadiologyModality.mri,
        preparationNote: 'x' * 201,
      );
      expect(
        validation.serviceError(detailsInvalid),
        InstitutionErrorCode.preparationNoteTooLong,
      );

      final validService = Examination(
        id: EntityConstants.unsavedId,
        name: 'Valid Service',
        departmentId: 'dept-1',
        branchId: 'b1',
        duration: ServiceDuration(20),
        fee: Money.minorUnits(10000),
      );
      expect(validation.serviceError(validService), isNull);
    });
  });
}
