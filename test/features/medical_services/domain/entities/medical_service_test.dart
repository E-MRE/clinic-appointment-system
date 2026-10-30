import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/recording_medical_service_visitor.dart';

void main() {
  group('MedicalService hierarchy', () {
    test('Examination exposes kind, accepts visitor, trims and updates id', () {
      final exam = Examination(
        id: MedicalService.unsavedId,
        name: '  General Checkup  ',
        departmentId: '  dept-1  ',
        branchId: '  branch-1  ',
        duration: ServiceDuration(30),
        fee: Money.kurus(50000),
      );

      expect(exam.kind, MedicalServiceKind.examination);
      expect(exam.detailsError, isNull);

      final visitor = RecordingMedicalServiceVisitor();
      final result = exam.accept(visitor);
      expect(result, 'examination:  General Checkup  ');
      expect(visitor.visitedExamination, same(exam));

      final trimmed = exam.trimmed();
      expect(trimmed.name, 'General Checkup');
      expect(trimmed.departmentId, 'dept-1');
      expect(trimmed.branchId, 'branch-1');
      expect(trimmed.duration, exam.duration);
      expect(trimmed.fee, exam.fee);

      final withNewId = exam.withId('saved-id');
      expect(withNewId.id, 'saved-id');
      expect(withNewId.name, exam.name);
      expect(withNewId.departmentId, exam.departmentId);
      expect(withNewId.branchId, exam.branchId);
      expect(withNewId.duration, exam.duration);
      expect(withNewId.fee, exam.fee);
    });

    test(
      'RadiologyService exposes modality, trims note, and checks note length',
      () {
        final radiology = RadiologyService(
          id: MedicalService.unsavedId,
          name: '  Chest X-Ray  ',
          departmentId: 'dept-2',
          branchId: 'branch-1',
          duration: ServiceDuration(15),
          fee: Money.kurus(75000),
          modality: RadiologyModality.xRay,
          preparationNote: '   ',
        );

        expect(radiology.kind, MedicalServiceKind.radiology);
        expect(radiology.modality, RadiologyModality.xRay);

        final visitor = RecordingMedicalServiceVisitor();
        final result = radiology.accept(visitor);
        expect(result, 'radiology:  Chest X-Ray  ');
        expect(visitor.visitedRadiology, same(radiology));

        final trimmedBlankNote = radiology.trimmed();
        expect(trimmedBlankNote.name, 'Chest X-Ray');
        expect(trimmedBlankNote.preparationNote, isNull);

        final withNote = RadiologyService(
          id: 'r1',
          name: 'MRI Brain',
          departmentId: 'dept-2',
          branchId: 'branch-1',
          duration: ServiceDuration(45),
          fee: Money.kurus(200000),
          modality: RadiologyModality.mri,
          preparationNote: '  Remove metal objects  ',
        );
        final trimmedWithNote = withNote.trimmed();
        expect(trimmedWithNote.preparationNote, 'Remove metal objects');

        final withNewId = withNote.withId('new-rad-id');
        expect(withNewId.id, 'new-rad-id');
        expect(withNewId.name, withNote.name);
        expect(withNewId.modality, RadiologyModality.mri);
        expect(withNewId.preparationNote, withNote.preparationNote);

        final note200 = 'a' * 200;
        final rad200 = RadiologyService(
          id: 'r2',
          name: 'CT Scan',
          departmentId: 'dept-2',
          branchId: 'branch-1',
          duration: ServiceDuration(20),
          fee: Money.kurus(150000),
          modality: RadiologyModality.ct,
          preparationNote: note200,
        );
        expect(rad200.detailsError, isNull);

        final note201 = 'a' * 201;
        final rad201 = RadiologyService(
          id: 'r3',
          name: 'CT Scan',
          departmentId: 'dept-2',
          branchId: 'branch-1',
          duration: ServiceDuration(20),
          fee: Money.kurus(150000),
          modality: RadiologyModality.ct,
          preparationNote: note201,
        );
        expect(
          rad201.detailsError,
          InstitutionErrorCode.preparationNoteTooLong,
        );

        final noteWithSpaces = '   $note200   ';
        final radWithSpaces = RadiologyService(
          id: 'r4',
          name: 'CT Scan',
          departmentId: 'dept-2',
          branchId: 'branch-1',
          duration: ServiceDuration(20),
          fee: Money.kurus(150000),
          modality: RadiologyModality.ct,
          preparationNote: noteWithSpaces,
        );
        expect(radWithSpaces.detailsError, isNull);
      },
    );

    test('LabTest manages fasting requirement, result time and trimming', () {
      final noFasting = LabTest(
        id: MedicalService.unsavedId,
        name: '  Complete Blood Count  ',
        departmentId: 'dept-3',
        branchId: 'branch-1',
        duration: ServiceDuration(10),
        fee: Money.kurus(35000),
        resultTime: LabResultTime.sameDay,
      );

      expect(noFasting.kind, MedicalServiceKind.lab);
      expect(noFasting.requiresFasting, isFalse);
      expect(noFasting.fastingHours, isNull);
      expect(noFasting.resultTime, LabResultTime.sameDay);
      expect(noFasting.detailsError, isNull);

      final visitor = RecordingMedicalServiceVisitor();
      final result = noFasting.accept(visitor);
      expect(result, 'lab:  Complete Blood Count  ');
      expect(visitor.visitedLabTest, same(noFasting));

      final trimmed = noFasting.trimmed();
      expect(trimmed.name, 'Complete Blood Count');
      expect(trimmed.requiresFasting, isFalse);

      final withFasting = LabTest(
        id: 'lab-1',
        name: 'Fasting Blood Glucose',
        departmentId: 'dept-3',
        branchId: 'branch-1',
        duration: ServiceDuration(10),
        fee: Money.kurus(25000),
        resultTime: LabResultTime.oneDay,
        fastingHours: FastingHours(min: 8, max: 12),
      );
      expect(withFasting.requiresFasting, isTrue);
      expect(withFasting.fastingHours?.min, 8);
      expect(withFasting.fastingHours?.max, 12);

      final withNewId = withFasting.withId('new-lab-id');
      expect(withNewId.id, 'new-lab-id');
      expect(withNewId.name, withFasting.name);
      expect(withNewId.resultTime, LabResultTime.oneDay);
      expect(withNewId.fastingHours, withFasting.fastingHours);
      expect(withNewId.requiresFasting, isTrue);
    });
  });
}
