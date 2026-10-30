import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_filter_chips.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_data_table.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/create_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/update_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_editor_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_filter_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_form_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_save_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/pages/medical_services_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../institution/domain/doubles/fake_branch_repository.dart';
import '../../../institution/domain/doubles/fake_department_repository.dart';
import '../../domain/doubles/fake_medical_service_repository.dart';

void main() {
  late FakeBranchRepository branchRepo;
  late FakeDepartmentRepository departmentRepo;
  late FakeMedicalServiceRepository serviceRepo;
  late StreamController<DataResult<List<Branch>>> branchStream;
  late StreamController<DataResult<List<Department>>> departmentStream;
  late StreamController<DataResult<List<MedicalService>>> serviceStream;
  late BranchListCubit branchListCubit;
  late DepartmentListCubit departmentListCubit;
  late MedicalServiceListCubit serviceListCubit;
  late InstitutionSelection selection;

  final branch = Branch(
    id: 'b1',
    clinicId: 'c1',
    name: 'Ana Şube',
    address: 'Atatürk Cad. No: 1',
    workingHours: WorkingHours.closed(),
  );

  const departmentCardiology = Department(
    id: 'd-cardio',
    branchId: 'b1',
    name: 'Kardiyoloji',
  );

  const departmentRadiology = Department(
    id: 'd-radio',
    branchId: 'b1',
    name: 'Radyoloji',
  );

  final serviceExamination = Examination(
    id: 's1',
    name: 'Kardiyoloji Muayenesi',
    departmentId: 'd-cardio',
    branchId: 'b1',
    duration: ServiceDuration(20),
    fee: Money.kurus(120000),
  );

  final serviceRadiology = RadiologyService(
    id: 's2',
    name: 'Akciğer Grafisi',
    departmentId: 'd-radio',
    branchId: 'b1',
    duration: ServiceDuration(15),
    fee: Money.kurus(65000),
    modality: RadiologyModality.xRay,
    preparationNote: 'metal takıları çıkarın',
  );

  final testServices = <MedicalService>[serviceExamination, serviceRadiology];

  setUp(() {
    branchRepo = FakeBranchRepository();
    departmentRepo = FakeDepartmentRepository();
    serviceRepo = FakeMedicalServiceRepository();

    branchStream = StreamController<DataResult<List<Branch>>>.broadcast();
    departmentStream =
        StreamController<DataResult<List<Department>>>.broadcast();
    serviceStream =
        StreamController<DataResult<List<MedicalService>>>.broadcast();

    branchRepo.branchesStream = branchStream.stream;
    departmentRepo.departmentsStream = departmentStream.stream;
    serviceRepo.servicesStream = serviceStream.stream;

    branchListCubit = BranchListCubit(WatchBranchesUseCase(branchRepo));
    departmentListCubit = DepartmentListCubit(
      WatchDepartmentsUseCase(departmentRepo),
    );
    serviceListCubit = MedicalServiceListCubit(
      WatchMedicalServicesUseCase(serviceRepo),
    );

    selection = InstitutionSelection();
    selection.selectClinic('c1');
    selection.selectBranch('b1');

    AppDependency.injector.registerFactory<MedicalServiceFilterCubit>(
      MedicalServiceFilterCubit.new,
    );
    AppDependency.injector.registerFactory<MedicalServiceEditorCubit>(
      MedicalServiceEditorCubit.new,
    );
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
    await branchListCubit.close();
    await departmentListCubit.close();
    await serviceListCubit.close();
    await branchStream.close();
    await departmentStream.close();
    await serviceStream.close();
    selection.dispose();
    await AppDependency.injector.reset();
  });

  Widget wrapWithProviders(Widget child) {
    return InstitutionSelectionScope(
      selection: selection,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BranchListCubit>.value(value: branchListCubit),
          BlocProvider<DepartmentListCubit>.value(value: departmentListCubit),
          BlocProvider<MedicalServiceListCubit>.value(value: serviceListCubit),
        ],
        child: child,
      ),
    );
  }

  testWidgets(
    'desktop width shows table rows with name, department, duration and fee',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await branchListCubit.watch('c1');
      await departmentListCubit.watch('b1');
      await serviceListCubit.watch('b1');

      await loadTestTranslations(
        tester,
        theme: LightTheme(ScreenSize.desktop).themeData,
        child: wrapWithProviders(const MedicalServicesPage()),
      );

      await tester.runAsync(() async {
        branchStream.add(DataResult.success(data: [branch]));
        departmentStream.add(
          const DataResult.success(
            data: [departmentCardiology, departmentRadiology],
          ),
        );
        serviceStream.add(DataResult.success(data: testServices));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();

      // Page header and subtitle
      expect(find.text('Hizmetler'), findsOneWidget);
      expect(
        find.text(
          '2 hizmet · süre ve ücret randevu ekranında hastaya gösterilir',
        ),
        findsOneWidget,
      );

      // Branch selector and add button
      expect(find.text('Ana Şube'), findsOneWidget);
      expect(find.widgetWithText(FilledButton, 'Hizmet ekle'), findsOneWidget);

      // AppDataTable rows
      expect(find.byType(AppDataTable<MedicalService>), findsOneWidget);
      expect(find.text('Kardiyoloji Muayenesi'), findsOneWidget);
      expect(find.text('Kardiyoloji'), findsOneWidget);
      expect(find.text('20 dk'), findsOneWidget);
      expect(find.text('₺1.200'), findsOneWidget);

      expect(find.text('Akciğer Grafisi'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(Table),
          matching: find.text('Radyoloji'),
        ),
        findsOneWidget,
      );
      expect(find.text('15 dk'), findsOneWidget);
      expect(find.text('₺650'), findsOneWidget);
    },
  );

  testWidgets(
    'tapping filter chip filters table rows and shows filtered-empty',
    (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await branchListCubit.watch('c1');
      await departmentListCubit.watch('b1');
      await serviceListCubit.watch('b1');

      await loadTestTranslations(
        tester,
        theme: LightTheme(ScreenSize.desktop).themeData,
        child: wrapWithProviders(const MedicalServicesPage()),
      );

      await tester.runAsync(() async {
        branchStream.add(DataResult.success(data: [branch]));
        departmentStream.add(
          const DataResult.success(
            data: [departmentCardiology, departmentRadiology],
          ),
        );
        serviceStream.add(DataResult.success(data: testServices));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();

      // Filter chips
      expect(
        find.byType(AppFilterChips<MedicalServiceKindFilter>),
        findsOneWidget,
      );
      expect(find.text('Tümü · 2'), findsOneWidget);
      expect(find.text('Muayene · 1'), findsOneWidget);
      expect(find.text('Radyoloji · 1'), findsOneWidget);
      expect(find.text('Laboratuvar · 0'), findsOneWidget);

      // Tap Radiology filter chip
      await tester.tap(find.text('Radyoloji · 1'));
      await tester.pumpAndSettle();

      expect(find.text('Akciğer Grafisi'), findsOneWidget);
      expect(find.text('Kardiyoloji Muayenesi'), findsNothing);

      // Tap Lab filter chip (count is 0 -> filtered-empty state)
      await tester.tap(find.text('Laboratuvar · 0'));
      await tester.pumpAndSettle();

      expect(find.text('Bu türde hizmet yok'), findsOneWidget);
      expect(find.text('Akciğer Grafisi'), findsNothing);
      expect(find.text('Kardiyoloji Muayenesi'), findsNothing);
    },
  );

  testWidgets(
    'mobile width shows department headers with cards in order and FAB',
    (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await branchListCubit.watch('c1');
      await departmentListCubit.watch('b1');
      await serviceListCubit.watch('b1');

      await loadTestTranslations(
        tester,
        theme: LightTheme(ScreenSize.mobile).themeData,
        child: wrapWithProviders(const MedicalServicesPage()),
      );

      await tester.runAsync(() async {
        branchStream.add(DataResult.success(data: [branch]));
        departmentStream.add(
          const DataResult.success(
            data: [departmentCardiology, departmentRadiology],
          ),
        );
        serviceStream.add(DataResult.success(data: testServices));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();

      // Header subtitle on mobile
      expect(find.text('2 hizmet · 2 bölüm'), findsOneWidget);

      // Mobile department headers
      expect(find.text('Kardiyoloji'), findsOneWidget);
      expect(find.text('Radyoloji'), findsOneWidget);

      // Service cards
      expect(find.text('Kardiyoloji Muayenesi'), findsOneWidget);
      expect(find.text('Muayene · 20 dk'), findsOneWidget);
      expect(find.text('Doktor muayenesi'), findsOneWidget);
      expect(find.text('₺1.200'), findsOneWidget);

      expect(find.text('Akciğer Grafisi'), findsOneWidget);
      expect(find.text('Radyoloji · Röntgen · 15 dk'), findsOneWidget);
      expect(find.text('Hazırlık: metal takıları çıkarın'), findsOneWidget);
      expect(find.text('₺650'), findsOneWidget);

      // Floating action button on mobile
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.text('Hizmet ekle'), findsOneWidget);
    },
  );

  testWidgets('displays loading, failure and empty states', (tester) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await branchListCubit.watch('c1');
    await serviceListCubit.watch('b1');

    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.desktop).themeData,
      child: wrapWithProviders(const MedicalServicesPage()),
    );

    // 1. Loading state
    expect(find.byType(LoadingState), findsOneWidget);

    // 2. Failure state
    await tester.runAsync(() async {
      serviceStream.add(const DataResult.error());
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();

    expect(find.text('Tekrar dene'), findsOneWidget);

    // 3. Empty state
    await tester.runAsync(() async {
      serviceStream.add(const DataResult.success(data: <MedicalService>[]));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();

    expect(find.text('Bu şubede henüz hizmet yok'), findsOneWidget);
  });

  testWidgets('tapping retry in failure state re-watches branch services', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await branchListCubit.watch('c1');
    await serviceListCubit.watch('b1');

    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.desktop).themeData,
      child: wrapWithProviders(const MedicalServicesPage()),
    );

    await tester.runAsync(() async {
      serviceStream.add(const DataResult.error());
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();

    expect(find.text('Tekrar dene'), findsOneWidget);

    serviceRepo.watchedBranchId = null;
    await tester.runAsync(() async {
      await tester.tap(find.text('Tekrar dene'));
      await Future<void>.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    expect(serviceRepo.watchedBranchId, 'b1');
  });

  testWidgets('no branch selected renders no-branch empty state', (
    tester,
  ) async {
    selection.clearBranch();

    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.desktop).themeData,
      child: wrapWithProviders(const MedicalServicesPage()),
    );
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Önce bir şube ekleyin'), findsOneWidget);
    expect(find.text('Kurum ve şubeler'), findsOneWidget);
  });

  testWidgets(
    'desktop panel switches to edit on row click and resets to create on save',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await branchListCubit.watch('c1');
      await departmentListCubit.watch('b1');
      await serviceListCubit.watch('b1');

      await loadTestTranslations(
        tester,
        theme: LightTheme(ScreenSize.desktop).themeData,
        child: wrapWithProviders(const MedicalServicesPage()),
      );

      await tester.runAsync(() async {
        branchStream.add(DataResult.success(data: [branch]));
        departmentStream.add(
          const DataResult.success(
            data: [departmentCardiology, departmentRadiology],
          ),
        );
        serviceStream.add(DataResult.success(data: testServices));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();

      // Right panel starts in create mode (no "Hizmeti düzenle" title)
      expect(find.text('Hizmeti düzenle'), findsNothing);

      // Tap edit button on the first service ('Kardiyoloji Muayenesi')
      final editButton = find.byIcon(Icons.edit_outlined).first;
      await tester.ensureVisible(editButton);
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // Now in edit mode
      expect(find.text('Hizmeti düzenle'), findsOneWidget);

      // Prepare repository update result
      serviceRepo.updateResult = DataResult.success(data: serviceExamination);

      // Tap save button in the panel
      final saveButton = find.text('Hizmeti kaydet');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();

      // After successful save, panel resets to create mode
      expect(find.text('Hizmeti düzenle'), findsNothing);
    },
  );

  testWidgets('tablet dialog opens on add and closes on successful save', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1024);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await branchListCubit.watch('c1');
    await departmentListCubit.watch('b1');
    await serviceListCubit.watch('b1');

    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.tablet).themeData,
      child: wrapWithProviders(const MedicalServicesPage()),
    );

    await tester.runAsync(() async {
      branchStream.add(DataResult.success(data: [branch]));
      departmentStream.add(
        const DataResult.success(
          data: [departmentCardiology, departmentRadiology],
        ),
      );
      serviceStream.add(DataResult.success(data: testServices));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();

    // Right panel does not exist on tablet
    expect(find.text('Hizmeti kaydet'), findsNothing);

    // Tap header add button
    await tester.tap(find.widgetWithText(FilledButton, 'Hizmet ekle'));
    await tester.pumpAndSettle();

    // Dialog opens
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Vazgeç'), findsOneWidget);
    expect(find.text('Hizmeti kaydet'), findsOneWidget);

    // Enter form data
    await tester.enterText(
      find.widgetWithText(TextFormField, '').first,
      'New Ultrasound',
    );
    // Select department
    await tester.tap(
      find.descendant(
        of: find.byType(Dialog),
        matching: find.byType(DropdownButtonFormField<String>),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kardiyoloji').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, '5–240 dakika'),
      '30',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'KDV dahil'),
      '500',
    );

    serviceRepo.createResult = DataResult.success(data: serviceExamination);

    // Tap save in dialog
    await tester.tap(find.text('Hizmeti kaydet'));
    await tester.pumpAndSettle();

    // Dialog closes
    expect(find.byType(Dialog), findsNothing);
  });
}
