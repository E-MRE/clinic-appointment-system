import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_segmented_control.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/create_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/update_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_form_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_save_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/widgets/medical_service_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../institution/domain/doubles/fake_department_repository.dart';
import '../../domain/doubles/fake_medical_service_repository.dart';

void main() {
  late FakeDepartmentRepository departmentRepo;
  late FakeMedicalServiceRepository serviceRepo;
  late StreamController<DataResult<List<Department>>> departmentStream;
  late DepartmentListCubit departmentListCubit;
  late InstitutionSelection selection;

  const departmentCardio = Department(
    id: 'dept-cardio',
    branchId: 'branch-1',
    name: 'Kardiyoloji',
  );

  const departmentRadio = Department(
    id: 'dept-radio',
    branchId: 'branch-1',
    name: 'Radyoloji',
  );

  setUp(() {
    departmentRepo = FakeDepartmentRepository();
    serviceRepo = FakeMedicalServiceRepository();
    departmentStream =
        StreamController<DataResult<List<Department>>>.broadcast();
    departmentRepo.departmentsStream = departmentStream.stream;

    departmentListCubit = DepartmentListCubit(
      WatchDepartmentsUseCase(departmentRepo),
    );

    selection = InstitutionSelection();
    selection.selectClinic('clinic-1');
    selection.selectBranch('branch-1');

    AppDependency.injector.registerFactory<MedicalServiceFormCubit>(
      MedicalServiceFormCubit.new,
    );
    AppDependency.injector.registerFactory<MedicalServiceSaveCubit>(
      () => MedicalServiceSaveCubit(
        CreateMedicalServiceUseCase(serviceRepo),
        UpdateMedicalServiceUseCase(serviceRepo),
      ),
    );
  });

  tearDown(() async {
    await departmentListCubit.close();
    await departmentStream.close();
    selection.dispose();
    await AppDependency.injector.reset();
  });

  Widget wrapWithScope(Widget child) {
    return InstitutionSelectionScope(
      selection: selection,
      child: BlocProvider<DepartmentListCubit>.value(
        value: departmentListCubit,
        child: Material(child: SingleChildScrollView(child: child)),
      ),
    );
  }

  Future<void> pumpForm(
    WidgetTester tester, {
    MedicalService? service,
    ValueChanged<MedicalService>? onSaved,
    VoidCallback? onCancel,
  }) async {
    tester.view.physicalSize = const Size(1200, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await departmentListCubit.watch('branch-1');

    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.desktop).themeData,
      child: wrapWithScope(
        MedicalServiceForm(
          service: service,
          branchId: 'branch-1',
          onSaved: onSaved ?? (_) {},
          onCancel: onCancel,
        ),
      ),
    );

    await tester.runAsync(() async {
      departmentStream.add(
        const DataResult.success(data: [departmentCardio, departmentRadio]),
      );
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  group('MedicalServiceForm', () {
    testWidgets(
      'kind switching shows modality and note for radiology, lab fields for lab, and neither for examination',
      (tester) async {
        await pumpForm(tester);

        // Initial examination kind: neither radiology nor lab special surfaces
        expect(find.text('RADYOLOJİYE ÖZEL'), findsNothing);
        expect(find.text('LABORATUVAR TESTİNE ÖZEL'), findsNothing);
        expect(find.text('Hazırlık notu (hastaya gösterilir)'), findsNothing);

        // Switch to Radyoloji
        await tester.tap(find.text('Radyoloji'));
        await tester.pumpAndSettle();

        expect(find.text('RADYOLOJİYE ÖZEL'), findsOneWidget);
        expect(find.text('Röntgen'), findsOneWidget);
        expect(find.text('Ultrason'), findsOneWidget);
        expect(find.text('MR'), findsOneWidget);
        expect(find.text('BT'), findsOneWidget);
        expect(find.text('Hazırlık notu (hastaya gösterilir)'), findsOneWidget);
        expect(find.text('LABORATUVAR TESTİNE ÖZEL'), findsNothing);

        // Switch to Laboratuvar
        await tester.tap(find.text('Laboratuvar'));
        await tester.pumpAndSettle();

        expect(find.text('LABORATUVAR TESTİNE ÖZEL'), findsOneWidget);
        expect(find.text('Aç gelmek gerekli'), findsOneWidget);
        expect(find.text('Açlık süresi (saat)'), findsOneWidget);
        expect(find.text('Sonuç süresi'), findsOneWidget);
        expect(find.text('RADYOLOJİYE ÖZEL'), findsNothing);

        // Switch back to Muayene
        await tester.tap(find.text('Muayene'));
        await tester.pumpAndSettle();

        expect(find.text('RADYOLOJİYE ÖZEL'), findsNothing);
        expect(find.text('LABORATUVAR TESTİNE ÖZEL'), findsNothing);
      },
    );

    testWidgets('fasting field is disabled until switch is toggled on', (
      tester,
    ) async {
      await pumpForm(tester);

      // Select Laboratuvar
      await tester.tap(find.text('Laboratuvar'));
      await tester.pumpAndSettle();

      final fastingInputFinder = find.widgetWithText(TextFormField, '8–12');
      expect(fastingInputFinder, findsOneWidget);

      expect(tester.widget<TextFormField>(fastingInputFinder).enabled, isFalse);

      // Toggle fasting switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(tester.widget<TextFormField>(fastingInputFinder).enabled, isTrue);

      // Toggle fasting switch off
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(tester.widget<TextFormField>(fastingInputFinder).enabled, isFalse);
    });

    testWidgets(
      'validators show messages for duration 4, fee 0, fasting 12-8, 201-character note',
      (tester) async {
        await pumpForm(tester);

        // Fill valid name and select department
        await tester.enterText(
          find.widgetWithText(TextFormField, '').first,
          'Test Service',
        );
        await tester.pumpAndSettle();

        // Duration 4 (invalid, min 5)
        final durationField = find.widgetWithText(
          TextFormField,
          '5–240 dakika',
        );
        await tester.enterText(durationField, '4');

        // Fee 0 (invalid, min 1)
        final feeField = find.widgetWithText(TextFormField, 'KDV dahil');
        await tester.enterText(feeField, '0');

        await tester.tap(find.text('Hizmeti kaydet'));
        await tester.pumpAndSettle();

        expect(find.text('Süre 5–240 dakika arasında olmalı.'), findsOneWidget);
        expect(
          find.text(
            'Ücret 1 ₺ ile 100.000 ₺ arasında olmalı (en fazla 2 ondalık).',
          ),
          findsOneWidget,
        );

        // Test fasting 12-8 (invalid range min > max)
        await tester.tap(find.text('Laboratuvar'));
        await tester.pumpAndSettle();
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        final fastingField = find.widgetWithText(TextFormField, '8–12');
        await tester.enterText(fastingField, '12-8');

        await tester.ensureVisible(find.text('Hizmeti kaydet'));
        await tester.tap(find.text('Hizmeti kaydet'));
        await tester.pumpAndSettle();

        expect(
          find.text(
            'Açlık süresi 1–24 saat arasında olmalı; en az değer en çoktan büyük olamaz.',
          ),
          findsOneWidget,
        );

        // Test 201-character preparation note
        await tester.tap(find.text('Radyoloji'));
        await tester.pumpAndSettle();

        final noteField = find.byType(TextFormField).last;
        final longNote = 'A' * 201;
        await tester.enterText(noteField, longNote);

        await tester.ensureVisible(find.text('Hizmeti kaydet'));
        await tester.tap(find.text('Hizmeti kaydet'));
        await tester.pumpAndSettle();

        expect(
          find.text('Hazırlık notu en fazla 200 karakter olabilir.'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'edit mode disables kind control and department select and prefills values',
      (tester) async {
        final existing = RadiologyService(
          id: 's-edit-1',
          name: 'Beyin MR',
          departmentId: 'dept-radio',
          branchId: 'branch-1',
          duration: ServiceDuration(30),
          fee: Money.kurus(150000),
          modality: RadiologyModality.mri,
          preparationNote: 'Metal nesneleri çıkarın',
        );

        await pumpForm(tester, service: existing);

        // Prefilled values
        expect(find.text('Beyin MR'), findsOneWidget);
        expect(find.text('30'), findsOneWidget);
        expect(find.text('1500'), findsOneWidget);
        expect(find.text('Metal nesneleri çıkarın'), findsOneWidget);

        // Kind control is disabled
        final segmented = tester
            .widget<AppSegmentedControl<MedicalServiceKind>>(
              find.byType(AppSegmentedControl<MedicalServiceKind>),
            );
        expect(segmented.enabled, isFalse);

        // Department select is disabled
        final select = tester.widget<AppSelectField<String>>(
          find.byType(AppSelectField<String>),
        );
        expect(select.enabled, isFalse);
      },
    );
  });
}
