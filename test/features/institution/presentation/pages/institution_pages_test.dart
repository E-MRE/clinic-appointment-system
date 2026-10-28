import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/working_hours_editor_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/branch_form_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_page.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/department_section.dart';
import 'package:clinic_appointment_system/features/institution/presentation/widgets/working_hours_editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../domain/doubles/fake_branch_repository.dart';
import '../../domain/doubles/fake_clinic_repository.dart';
import '../../domain/doubles/fake_department_repository.dart';

void main() {
  late FakeClinicRepository clinicRepo;
  late FakeBranchRepository branchRepo;
  late FakeDepartmentRepository departmentRepo;
  late StreamController<DataResult<List<Clinic>>> clinicStream;
  late StreamController<DataResult<List<Branch>>> branchStream;
  late StreamController<DataResult<List<Department>>> departmentStream;
  late ClinicListCubit clinics;
  late BranchListCubit branches;
  late DepartmentListCubit departments;
  late InstitutionSelection selection;

  setUp(() {
    clinicRepo = FakeClinicRepository();
    branchRepo = FakeBranchRepository();
    departmentRepo = FakeDepartmentRepository();
    clinicStream = StreamController.broadcast();
    branchStream = StreamController.broadcast();
    departmentStream = StreamController.broadcast();
    clinicRepo.clinicsStream = clinicStream.stream;
    branchRepo.branchesStream = branchStream.stream;
    departmentRepo.departmentsStream = departmentStream.stream;
    clinics = ClinicListCubit(WatchClinicsUseCase(clinicRepo));
    branches = BranchListCubit(WatchBranchesUseCase(branchRepo));
    departments = DepartmentListCubit(WatchDepartmentsUseCase(departmentRepo));
    selection = InstitutionSelection();
  });

  tearDown(() async {
    await clinics.close();
    await branches.close();
    await departments.close();
    await clinicStream.close();
    await branchStream.close();
    await departmentStream.close();
    selection.dispose();
  });

  Widget wrap(Widget child) => InstitutionSelectionScope(
    selection: selection,
    child: MultiBlocProvider(
      providers: [
        BlocProvider<ClinicListCubit>.value(value: clinics),
        BlocProvider<BranchListCubit>.value(value: branches),
        BlocProvider<DepartmentListCubit>.value(value: departments),
      ],
      child: child,
    ),
  );

  ClinicSaveCubit clinicSave() => ClinicSaveCubit(
    CreateClinicUseCase(clinicRepo),
    UpdateClinicUseCase(clinicRepo),
  );
  BranchSaveCubit branchSave() => BranchSaveCubit(
    CreateBranchUseCase(branchRepo),
    UpdateBranchUseCase(branchRepo),
  );
  DepartmentSaveCubit departmentSave() => DepartmentSaveCubit(
    CreateDepartmentUseCase(departmentRepo),
    UpdateDepartmentUseCase(departmentRepo),
  );

  for (final size in [const Size(390, 844), const Size(1200, 900)]) {
    testWidgets('institution loading, error, empty and loaded at $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await loadTestTranslations(
        tester,
        theme: LightTheme(ScreenSize.mobile).themeData,
        child: wrap(
          InstitutionPage(
            createClinicSaveCubit: clinicSave,
            createDepartmentSaveCubit: departmentSave,
          ),
        ),
      );
      expect(find.byType(LoadingState), findsOneWidget);
      await tester.runAsync(() async {
        clinicStream.add(const DataResult.error());
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(find.text('Tekrar dene'), findsOneWidget);
      await tester.runAsync(() async {
        clinicStream.add(const DataResult.success(data: <Clinic>[]));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(find.text('Henüz kurum yok'), findsOneWidget);
      await tester.tap(find.text('Kurum ekle'));
      await tester.pumpAndSettle();
      expect(find.text('Kurum adı'), findsOneWidget);
      await tester.tap(find.text('Vazgeç'));
      await tester.pumpAndSettle();
      selection.selectClinic('clinic-1');
      await branches.watch('clinic-1');
      await tester.runAsync(() async {
        clinicStream.add(
          const DataResult.success(
            data: [Clinic(id: 'clinic-1', name: 'Test Kliniği')],
          ),
        );
        await Future<void>.delayed(Duration.zero);
      });
      branchStream.add(
        DataResult.success(
          data: [
            Branch(
              id: 'branch-1',
              clinicId: 'clinic-1',
              name: 'Merkez',
              address: 'Ana cadde',
              workingHours: WorkingHours.closed(),
            ),
          ],
        ),
      );
      await departments.watch('branch-1');
      await tester.runAsync(() async {
        departmentStream.add(const DataResult.success(data: <Department>[]));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(find.text('Test Kliniği'), findsOneWidget);
      expect(find.text('Merkez'), findsWidgets);
    });
  }

  testWidgets('valid branch form sends name, address and hours', (
    tester,
  ) async {
    selection.selectClinic('clinic-1');
    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.mobile).themeData,
      child: wrap(BranchFormPage(createSaveCubit: branchSave)),
    );
    await tester.enterText(find.byType(TextFormField).at(0), 'Merkez');
    await tester.enterText(find.byType(TextFormField).at(1), 'Ana cadde');
    await tester.tap(find.text('Şubeyi kaydet'));
    await tester.pump();
    expect(branchRepo.createCalls, 1);
    expect(branchRepo.createdDraft?.name, 'Merkez');
    expect(branchRepo.createdDraft?.address, 'Ana cadde');
    expect(
      branchRepo.createdDraft?.workingHours.isClosedOn(Weekday.monday),
      false,
    );
  });

  testWidgets('inverted weekday range shows inline error and blocks save', (
    tester,
  ) async {
    selection.selectClinic('clinic-1');
    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.mobile).themeData,
      child: wrap(BranchFormPage(createSaveCubit: branchSave)),
    );
    final editor = tester
        .element(find.byType(WorkingHoursEditor))
        .read<WorkingHoursEditorCubit>();
    editor.updateRange(
      Weekday.monday,
      0,
      ClockTime(hour: 18, minute: 0),
      ClockTime(hour: 9, minute: 0),
    );
    await tester.pumpAndSettle();
    expect(editor.state.day(Weekday.monday).error, isNotNull);
    expect(
      find.text('Kapanış saati açılıştan sonra olmalı.', skipOffstage: false),
      findsOneWidget,
    );
    await tester.tap(find.text('Şubeyi kaydet'));
    await tester.pump();
    expect(branchRepo.createCalls, 0);
  });

  testWidgets('department inline add saves department', (tester) async {
    await departments.watch('branch-1');
    departmentStream.add(const DataResult.success(data: <Department>[]));
    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.mobile).themeData,
      child: Material(
        child: wrap(
          DepartmentSection(
            branchId: 'branch-1',
            createSaveCubit: departmentSave,
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(TextFormField), 'Kardiyoloji');
    await tester.tap(find.text('Ekle'));
    await tester.pump();
    expect(departmentRepo.createdDraft?.branchId, 'branch-1');
    expect(departmentRepo.createdDraft?.name, 'Kardiyoloji');
    expect(find.text('Kardiyoloji'), findsOneWidget);
    expect(
      find.text('İşlem tamamlanamadı. Lütfen tekrar deneyin.'),
      findsOneWidget,
    );
    departmentRepo.createResult = const DataResult.success(
      data: Department(id: 'd1', branchId: 'branch-1', name: 'Kardiyoloji'),
    );
    await tester.tap(find.text('Ekle'));
    await tester.pumpAndSettle();
    expect(find.text('Kardiyoloji'), findsNothing);
    expect(
      find.text('İşlem tamamlanamadı. Lütfen tekrar deneyin.'),
      findsNothing,
    );
  });

  testWidgets('department edit stays open on failure and closes on success', (
    tester,
  ) async {
    await departments.watch('branch-1');
    await loadTestTranslations(
      tester,
      theme: LightTheme(ScreenSize.mobile).themeData,
      settle: false,
      child: Material(
        child: wrap(
          DepartmentSection(
            branchId: 'branch-1',
            createSaveCubit: departmentSave,
          ),
        ),
      ),
    );
    await tester.runAsync(() async {
      departmentStream.add(
        const DataResult.success(
          data: [Department(id: 'd1', branchId: 'branch-1', name: 'Old')],
        ),
      );
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Düzenle'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).last, 'New');
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('New'), findsOneWidget);
    expect(
      find.text('İşlem tamamlanamadı. Lütfen tekrar deneyin.'),
      findsOneWidget,
    );
    departmentRepo.updateResult = const DataResult.success(
      data: Department(id: 'd1', branchId: 'branch-1', name: 'New'),
    );
    await tester.tap(find.text('Kaydet'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets(
    'clinic create keeps typed name on failure and closes on success',
    (tester) async {
      await loadTestTranslations(
        tester,
        theme: LightTheme(ScreenSize.mobile).themeData,
        child: wrap(
          InstitutionPage(
            createClinicSaveCubit: clinicSave,
            createDepartmentSaveCubit: departmentSave,
          ),
        ),
      );
      await tester.runAsync(() async {
        clinicStream.add(const DataResult.success(data: <Clinic>[]));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      await tester.tap(find.text('Kurum ekle'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextFormField), 'New Clinic');
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('New Clinic'), findsOneWidget);
      expect(
        find.text('İşlem tamamlanamadı. Lütfen tekrar deneyin.'),
        findsOneWidget,
      );
      clinicRepo.createResult = const DataResult.success(
        data: Clinic(id: 'new', name: 'New Clinic'),
      );
      await tester.tap(find.text('Kaydet'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    },
  );
}
