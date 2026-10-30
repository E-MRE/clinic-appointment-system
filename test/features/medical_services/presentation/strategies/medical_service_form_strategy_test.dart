import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_form_strategy.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/examination_form_strategy.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/lab_test_form_strategy.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/radiology_form_strategy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MedicalServiceFormStrategy', () {
    test('resolves the strategy of each domain kind', () {
      expect(
        MedicalServiceKind.examination.formStrategy,
        isA<ExaminationFormStrategy>(),
      );
      expect(
        MedicalServiceKind.radiology.formStrategy,
        isA<RadiologyFormStrategy>(),
      );
      expect(MedicalServiceKind.lab.formStrategy, isA<LabTestFormStrategy>());
    });

    test('builds Examination from form values', () {
      const values = MedicalServiceFormValues(
        kind: MedicalServiceKind.examination,
        name: '  Routine Examination  ',
        departmentId: '  dept-1  ',
        durationText: '20',
        feeText: '1200',
      );

      final service = const ExaminationFormStrategy().build(
        values,
        id: 's-exam',
        branchId: 'b-1',
      );

      expect(service, isA<Examination>());
      expect(service.id, 's-exam');
      expect(service.name, 'Routine Examination');
      expect(service.departmentId, 'dept-1');
      expect(service.branchId, 'b-1');
      expect(service.duration.minutes, 20);
      expect(service.fee.minorUnits, 120000);
    });

    test('builds RadiologyService with modality and note', () {
      const values = MedicalServiceFormValues(
        kind: MedicalServiceKind.radiology,
        name: 'Brain MRI',
        departmentId: 'dept-rad',
        durationText: '30',
        feeText: '1500,50',
        modality: RadiologyModality.mri,
        preparationNote: '  Remove jewelry  ',
      );

      final service = const RadiologyFormStrategy().build(
        values,
        id: 's-rad',
        branchId: 'b-1',
      );

      expect(service, isA<RadiologyService>());
      final radiology = service as RadiologyService;
      expect(radiology.modality, RadiologyModality.mri);
      expect(radiology.preparationNote, 'Remove jewelry');
      expect(radiology.fee.minorUnits, 150050);
    });

    test('builds RadiologyService with empty note normalizing to null', () {
      const values = MedicalServiceFormValues(
        kind: MedicalServiceKind.radiology,
        name: 'Ultrasound',
        departmentId: 'dept-rad',
        durationText: '15',
        feeText: '800',
        modality: RadiologyModality.ultrasound,
        preparationNote: '   ',
      );

      final service = const RadiologyFormStrategy().build(
        values,
        id: 's-rad',
        branchId: 'b-1',
      );

      expect((service as RadiologyService).preparationNote, isNull);
    });

    test('builds LabTest with fasting hours when requiresFasting is true', () {
      const values = MedicalServiceFormValues(
        kind: MedicalServiceKind.lab,
        name: 'Fasting Blood Glucose',
        departmentId: 'dept-lab',
        durationText: '10',
        feeText: '250',
        requiresFasting: true,
        fastingText: '8-12',
        resultTime: LabResultTime.sameDay,
      );

      final service = const LabTestFormStrategy().build(
        values,
        id: 's-lab',
        branchId: 'b-1',
      );

      expect(service, isA<LabTest>());
      final lab = service as LabTest;
      expect(lab.requiresFasting, isTrue);
      expect(lab.fastingHours, FastingHours(min: 8, max: 12));
      expect(lab.resultTime, LabResultTime.sameDay);
    });

    test(
      'builds LabTest ignoring fasting text when requiresFasting is false',
      () {
        const values = MedicalServiceFormValues(
          kind: MedicalServiceKind.lab,
          name: 'Blood Group Test',
          departmentId: 'dept-lab',
          durationText: '10',
          feeText: '150',
          requiresFasting: false,
          fastingText: 'invalid fasting text 123',
          resultTime: LabResultTime.oneDay,
        );

        final service = const LabTestFormStrategy().build(
          values,
          id: 's-lab',
          branchId: 'b-1',
        );

        final lab = service as LabTest;
        expect(lab.requiresFasting, isFalse);
        expect(lab.fastingHours, isNull);
      },
    );

    test(
      'parsing failures throw InstitutionException with domain error codes',
      () {
        const invalidDuration = MedicalServiceFormValues(
          kind: MedicalServiceKind.examination,
          name: 'Checkup',
          departmentId: 'd1',
          durationText: '3',
          feeText: '500',
        );
        expect(
          () => const ExaminationFormStrategy().build(
            invalidDuration,
            id: 's1',
            branchId: 'b1',
          ),
          throwsA(
            isA<InstitutionException>().having(
              (e) => e.code,
              'code',
              InstitutionErrorCode.invalidDuration,
            ),
          ),
        );

        const invalidFee = MedicalServiceFormValues(
          kind: MedicalServiceKind.examination,
          name: 'Checkup',
          departmentId: 'd1',
          durationText: '20',
          feeText: '0',
        );
        expect(
          () => const ExaminationFormStrategy().build(
            invalidFee,
            id: 's1',
            branchId: 'b1',
          ),
          throwsA(
            isA<InstitutionException>().having(
              (e) => e.code,
              'code',
              InstitutionErrorCode.invalidFee,
            ),
          ),
        );

        const invalidFasting = MedicalServiceFormValues(
          kind: MedicalServiceKind.lab,
          name: 'Lab Test',
          departmentId: 'd1',
          durationText: '20',
          feeText: '500',
          requiresFasting: true,
          fastingText: '12-8',
        );
        expect(
          () => const LabTestFormStrategy().build(
            invalidFasting,
            id: 's1',
            branchId: 'b1',
          ),
          throwsA(
            isA<InstitutionException>().having(
              (e) => e.code,
              'code',
              InstitutionErrorCode.invalidFastingHours,
            ),
          ),
        );
      },
    );
  });
}
