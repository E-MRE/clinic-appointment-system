import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/visitors/medical_service_form_values_visitor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MedicalServiceFormValuesVisitor', () {
    const visitor = MedicalServiceFormValuesVisitor();

    test('prefills examination values correctly', () {
      final service = Examination(
        id: 's-exam',
        name: 'Cardiology Checkup',
        departmentId: 'dept-1',
        branchId: 'branch-1',
        duration: ServiceDuration(20),
        fee: Money.kurus(120000),
      );

      final values = service.accept(visitor);

      expect(values.kind, MedicalServiceKind.examination);
      expect(values.name, 'Cardiology Checkup');
      expect(values.departmentId, 'dept-1');
      expect(values.durationText, '20');
      expect(values.feeText, '1200');
      expect(values.preparationNote, '');
      expect(values.requiresFasting, isFalse);
      expect(values.fastingText, '');
    });

    test('prefills radiology values with preparation note and modality', () {
      final service = RadiologyService(
        id: 's-rad',
        name: 'Chest X-Ray',
        departmentId: 'dept-radio',
        branchId: 'branch-1',
        duration: ServiceDuration(15),
        fee: Money.kurus(85050),
        modality: RadiologyModality.mri,
        preparationNote: 'Remove all metallic jewelry',
      );

      final values = service.accept(visitor);

      expect(values.kind, MedicalServiceKind.radiology);
      expect(values.name, 'Chest X-Ray');
      expect(values.departmentId, 'dept-radio');
      expect(values.durationText, '15');
      expect(values.feeText, '850,50');
      expect(values.modality, RadiologyModality.mri);
      expect(values.preparationNote, 'Remove all metallic jewelry');
    });

    test('prefills radiology values when note is null', () {
      final service = RadiologyService(
        id: 's-rad-null',
        name: 'Bone X-Ray',
        departmentId: 'dept-radio',
        branchId: 'branch-1',
        duration: ServiceDuration(10),
        fee: Money.kurus(50000),
        modality: RadiologyModality.xRay,
        preparationNote: null,
      );

      final values = service.accept(visitor);

      expect(values.preparationNote, '');
    });

    test('prefills lab test with fasting window enabled', () {
      final service = LabTest(
        id: 's-lab',
        name: 'Lipid Profile',
        departmentId: 'dept-lab',
        branchId: 'branch-1',
        duration: ServiceDuration(10),
        fee: Money.kurus(42000),
        resultTime: LabResultTime.sameDay,
        fastingHours: FastingHours(min: 8, max: 12),
      );

      final values = service.accept(visitor);

      expect(values.kind, MedicalServiceKind.lab);
      expect(values.name, 'Lipid Profile');
      expect(values.requiresFasting, isTrue);
      expect(values.fastingText, '8\u201312');
      expect(values.resultTime, LabResultTime.sameDay);
    });

    test('prefills lab test when fasting is disabled', () {
      final service = LabTest(
        id: 's-lab-nofasting',
        name: 'Complete Blood Count',
        departmentId: 'dept-lab',
        branchId: 'branch-1',
        duration: ServiceDuration(10),
        fee: Money.kurus(25000),
        resultTime: LabResultTime.twoDays,
        fastingHours: null,
      );

      final values = service.accept(visitor);

      expect(values.requiresFasting, isFalse);
      expect(values.fastingText, '');
      expect(values.resultTime, LabResultTime.twoDays);
    });
  });
}
