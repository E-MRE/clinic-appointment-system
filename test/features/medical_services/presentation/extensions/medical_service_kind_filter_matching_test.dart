import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/medical_service_kind_filter_matching.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MedicalServiceKindFilter', () {
    final exam = Examination(
      id: 'e-1',
      name: 'General Consultation',
      departmentId: 'd-1',
      branchId: 'b-1',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(40000),
    );

    final radiology = RadiologyService(
      id: 'r-1',
      name: 'Chest X-Ray',
      departmentId: 'd-2',
      branchId: 'b-1',
      duration: ServiceDuration(15),
      fee: Money.minorUnits(60000),
      modality: RadiologyModality.xRay,
    );

    final lab = LabTest(
      id: 'l-1',
      name: 'Blood Count',
      departmentId: 'd-3',
      branchId: 'b-1',
      duration: ServiceDuration(10),
      fee: Money.minorUnits(20000),
      fastingHours: FastingHours(min: 8, max: 12),
      resultTime: LabResultTime.sameDay,
    );

    test('all filter matches every service', () {
      const filter = MedicalServiceKindFilter.all;
      expect(filter.kind, isNull);
      expect(filter.matches(exam), isTrue);
      expect(filter.matches(radiology), isTrue);
      expect(filter.matches(lab), isTrue);
    });

    test('examination filter matches only examination services', () {
      const filter = MedicalServiceKindFilter.examination;
      expect(filter.kind, MedicalServiceKind.examination);
      expect(filter.matches(exam), isTrue);
      expect(filter.matches(radiology), isFalse);
      expect(filter.matches(lab), isFalse);
    });

    test('radiology filter matches only radiology services', () {
      const filter = MedicalServiceKindFilter.radiology;
      expect(filter.kind, MedicalServiceKind.radiology);
      expect(filter.matches(exam), isFalse);
      expect(filter.matches(radiology), isTrue);
      expect(filter.matches(lab), isFalse);
    });

    test('lab filter matches only lab test services', () {
      const filter = MedicalServiceKindFilter.lab;
      expect(filter.kind, MedicalServiceKind.lab);
      expect(filter.matches(exam), isFalse);
      expect(filter.matches(radiology), isFalse);
      expect(filter.matches(lab), isTrue);
    });
  });
}
