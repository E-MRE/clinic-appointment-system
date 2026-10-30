import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_list_overview.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  const departmentCardiology = Department(
    id: 'd-cardio',
    branchId: 'b1',
    name: 'Kardiyoloji',
  );
  const departmentInternal = Department(
    id: 'd-internal',
    branchId: 'b1',
    name: 'Dahiliye',
  );
  const departmentRadiology = Department(
    id: 'd-radio',
    branchId: 'b1',
    name: 'Radyoloji',
  );
  const departmentLab = Department(
    id: 'd-lab',
    branchId: 'b1',
    name: 'Laboratuvar',
  );
  final departments = [
    departmentCardiology,
    departmentInternal,
    departmentRadiology,
    departmentLab,
  ];

  final examination1 = Examination(
    id: 's1',
    name: 'Kardiyoloji Muayenesi',
    departmentId: 'd-cardio',
    branchId: 'b1',
    duration: ServiceDuration(20),
    fee: Money.kurus(120000),
  );
  final examination2 = Examination(
    id: 's2',
    name: 'EKG Çekimi',
    departmentId: 'd-cardio',
    branchId: 'b1',
    duration: ServiceDuration(10),
    fee: Money.kurus(40000),
  );
  final examination3 = Examination(
    id: 's3',
    name: 'Dahiliye Muayenesi',
    departmentId: 'd-internal',
    branchId: 'b1',
    duration: ServiceDuration(20),
    fee: Money.kurus(95000),
  );

  final radiology1 = RadiologyService(
    id: 's4',
    name: 'Akciğer Grafisi',
    departmentId: 'd-radio',
    branchId: 'b1',
    duration: ServiceDuration(15),
    fee: Money.kurus(65000),
    modality: RadiologyModality.xRay,
  );
  final radiology2 = RadiologyService(
    id: 's5',
    name: 'Diz Grafisi',
    departmentId: 'd-radio',
    branchId: 'b1',
    duration: ServiceDuration(15),
    fee: Money.kurus(60000),
    modality: RadiologyModality.xRay,
  );
  final radiology3 = RadiologyService(
    id: 's6',
    name: 'Batın Ultrasonu',
    departmentId: 'd-radio',
    branchId: 'b1',
    duration: ServiceDuration(20),
    fee: Money.kurus(90000),
    modality: RadiologyModality.ultrasound,
  );
  final radiology4 = RadiologyService(
    id: 's7',
    name: 'Boyun Ultrasonu',
    departmentId: 'd-radio',
    branchId: 'b1',
    duration: ServiceDuration(20),
    fee: Money.kurus(80000),
    modality: RadiologyModality.ultrasound,
  );

  final lab1 = LabTest(
    id: 's8',
    name: 'Lipid Paneli',
    departmentId: 'd-lab',
    branchId: 'b1',
    duration: ServiceDuration(10),
    fee: Money.kurus(42000),
    resultTime: LabResultTime.oneDay,
  );
  final lab2 = LabTest(
    id: 's9',
    name: 'Tam Kan Sayımı',
    departmentId: 'd-lab',
    branchId: 'b1',
    duration: ServiceDuration(10),
    fee: Money.kurus(25000),
    resultTime: LabResultTime.sameDay,
  );
  final lab3 = LabTest(
    id: 's10',
    name: 'Açlık Kan Şekeri',
    departmentId: 'd-lab',
    branchId: 'b1',
    duration: ServiceDuration(10),
    fee: Money.kurus(15000),
    resultTime: LabResultTime.sameDay,
  );
  final lab4 = LabTest(
    id: 's11',
    name: 'TSH',
    departmentId: 'd-lab',
    branchId: 'b1',
    duration: ServiceDuration(10),
    fee: Money.kurus(30000),
    resultTime: LabResultTime.oneDay,
  );
  final lab5 = LabTest(
    id: 's12',
    name: 'B12 Vitamini',
    departmentId: 'd-lab',
    branchId: 'b1',
    duration: ServiceDuration(10),
    fee: Money.kurus(32000),
    resultTime: LabResultTime.twoDays,
  );
  final lab6 = LabTest(
    id: 's13',
    name: 'Ferritin',
    departmentId: 'd-lab',
    branchId: 'b1',
    duration: ServiceDuration(10),
    fee: Money.kurus(28000),
    resultTime: LabResultTime.oneDay,
  );

  final allServices = <MedicalService>[
    examination1,
    examination2,
    examination3,
    radiology1,
    radiology2,
    radiology3,
    radiology4,
    lab1,
    lab2,
    lab3,
    lab4,
    lab5,
    lab6,
  ];

  testWidgets('computes accurate counts, subtitles, and chip labels', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final overview = MedicalServiceListOverview.from(
      services: allServices,
      departments: departments,
    );

    expect(overview.total, 13);
    expect(overview.examinationCount, 3);
    expect(overview.radiologyCount, 4);
    expect(overview.labCount, 6);
    expect(overview.distinctDepartmentsCount, 4);

    expect(
      overview.desktopSubtitle,
      '13 hizmet · süre ve ücret randevu ekranında hastaya gösterilir',
    );
    expect(overview.tabletSubtitle, '3 muayene · 4 radyoloji · 6 laboratuvar');
    expect(overview.mobileSubtitle, '13 hizmet · 4 bölüm');

    expect(overview.chipLabel(MedicalServiceKindFilter.all), 'Tümü · 13');
    expect(
      overview.chipLabel(MedicalServiceKindFilter.examination),
      'Muayene · 3',
    );
    expect(
      overview.chipLabel(MedicalServiceKindFilter.radiology),
      'Radyoloji · 4',
    );
    expect(overview.chipLabel(MedicalServiceKindFilter.lab), 'Laboratuvar · 6');
  });

  testWidgets(
    'groups services by department name and appends unknown departments last',
    (tester) async {
      await loadTestTranslations(tester);
      final unknownService = Examination(
        id: 's-unknown',
        name: 'Genel Kontrol',
        departmentId: 'd-nonexistent',
        branchId: 'b1',
        duration: ServiceDuration(15),
        fee: Money.kurus(50000),
      );

      final mixedServices = [
        unknownService,
        examination1,
        examination3,
        radiology1,
      ];
      final overview = MedicalServiceListOverview.from(
        services: mixedServices,
        departments: departments,
      );

      final groups = overview.groupServices(mixedServices);

      // Alphabetical order: Dahiliye, Kardiyoloji, Radyoloji, then Diğer
      expect(groups.length, 4);
      expect(groups[0].departmentName, 'Dahiliye');
      expect(groups[0].services, [examination3]);
      expect(groups[1].departmentName, 'Kardiyoloji');
      expect(groups[1].services, [examination1]);
      expect(groups[2].departmentName, 'Radyoloji');
      expect(groups[2].services, [radiology1]);
      expect(groups[3].departmentName, 'Diğer');
      expect(groups[3].services, [unknownService]);
    },
  );

  testWidgets('resolves known and unknown department names', (tester) async {
    await loadTestTranslations(tester);
    final overview = MedicalServiceListOverview.from(
      services: allServices,
      departments: departments,
    );

    expect(overview.departmentName('d-cardio'), 'Kardiyoloji');
    expect(overview.departmentName('non-existent-id'), '—');
  });
}
