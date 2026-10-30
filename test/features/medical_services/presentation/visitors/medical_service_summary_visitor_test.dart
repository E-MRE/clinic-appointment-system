import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/visitors/medical_service_summary_visitor.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  const visitor = MedicalServiceSummaryVisitor();

  testWidgets('visits examination service', (tester) async {
    await loadTestTranslations(tester);
    final service = Examination(
      id: 'e1',
      name: 'Kardiyoloji Muayenesi',
      departmentId: 'd1',
      branchId: 'b1',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(120000),
    );

    final summary = service.accept(visitor);
    expect(summary.tableSubtitle, 'Muayene');
    expect(summary.typeLine, 'Muayene · 20 dk');
    expect(summary.detail, 'Doktor muayenesi');
  });

  testWidgets('visits radiology service with preparation note', (tester) async {
    await loadTestTranslations(tester);
    final service = RadiologyService(
      id: 'r1',
      name: 'Akciğer Grafisi',
      departmentId: 'd2',
      branchId: 'b1',
      duration: ServiceDuration(15),
      fee: Money.minorUnits(65000),
      modality: RadiologyModality.xRay,
      preparationNote: 'metal takıları çıkarın',
    );

    final summary = service.accept(visitor);
    expect(summary.tableSubtitle, 'Röntgen · metal takıları çıkarın');
    expect(summary.typeLine, 'Radyoloji · Röntgen · 15 dk');
    expect(summary.detail, 'Hazırlık: metal takıları çıkarın');
  });

  testWidgets('visits radiology service without preparation note', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final service = RadiologyService(
      id: 'r2',
      name: 'Boyun Ultrasonu',
      departmentId: 'd2',
      branchId: 'b1',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(80000),
      modality: RadiologyModality.ultrasound,
    );

    final summary = service.accept(visitor);
    expect(summary.tableSubtitle, 'Ultrason · hazırlık gerekmez');
    expect(summary.typeLine, 'Radyoloji · Ultrason · 20 dk');
    expect(summary.detail, 'Hazırlık gerekmez');
  });

  testWidgets('visits lab test with fasting range and multi-day result', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final service = LabTest(
      id: 'l1',
      name: 'Lipid Paneli',
      departmentId: 'd3',
      branchId: 'b1',
      duration: ServiceDuration(10),
      fee: Money.minorUnits(42000),
      fastingHours: FastingHours(min: 8, max: 12),
      resultTime: LabResultTime.oneDay,
    );

    final summary = service.accept(visitor);
    expect(summary.tableSubtitle, 'Aç: 8–12 saat · Sonuç: 1 gün');
    expect(summary.typeLine, 'Laboratuvar · 10 dk');
    expect(summary.detail, 'Aç: 8–12 saat · Sonuç: 1 gün');
  });

  testWidgets('visits lab test without fasting and same-day result', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final service = LabTest(
      id: 'l2',
      name: 'Tam Kan Sayımı',
      departmentId: 'd3',
      branchId: 'b1',
      duration: ServiceDuration(10),
      fee: Money.minorUnits(25000),
      resultTime: LabResultTime.sameDay,
    );

    final summary = service.accept(visitor);
    expect(summary.tableSubtitle, 'Açlık gerekmez · Sonuç: aynı gün');
    expect(summary.typeLine, 'Laboratuvar · 10 dk');
    expect(summary.detail, 'Açlık gerekmez · Sonuç: aynı gün');
  });
}
