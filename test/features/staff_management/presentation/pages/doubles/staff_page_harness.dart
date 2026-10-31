import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/localization/localization_wrapper.dart';
import 'package:clinic_appointment_system/core/states/theme_cubit.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/create_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/update_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_department_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_editor_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_filter_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_form_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_save_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/pages/staff_management_route_scope.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../../../support/localization_test_app.dart';
import '../../../../institution/domain/doubles/fake_branch_repository.dart';
import '../../../../institution/domain/doubles/fake_clinic_repository.dart';
import '../../../../institution/domain/doubles/fake_department_repository.dart';
import '../../../../medical_services/domain/doubles/fake_medical_service_repository.dart';
import '../../../domain/doubles/fake_staff_account_provisioner.dart';
import '../../../domain/doubles/fake_staff_repository.dart';
import '../../../domain/doubles/fixed_temporary_password_generator.dart';
import '../../../domain/doubles/staff_fixtures.dart';

/// Real cubits and use cases with controllable repository boundaries.
final class StaffPageHarness {
  final FakeStaffRepository repository = FakeStaffRepository();
  final FakeBranchRepository branchRepository = FakeBranchRepository();
  final FakeDepartmentRepository departmentRepository =
      FakeDepartmentRepository();
  final FakeMedicalServiceRepository serviceRepository =
      FakeMedicalServiceRepository();
  final StreamController<DataResult<List<Staff>>> staffStream =
      StreamController.broadcast();
  final StreamController<DataResult<List<Branch>>> branchStream =
      StreamController.broadcast();
  final InstitutionSelection selection = InstitutionSelection();
  late final BranchListCubit branches;
  late StaffListCubit staff;
  late StaffDepartmentListCubit departments;
  late StaffServiceListCubit services;

  static const StaffFixtures fixtures = StaffFixtures();
  static const Size desktop = Size(1440, 960);
  static const Size tablet = Size(834, 1194);
  static const Size mobile = Size(390, 844);

  final List<Branch> clinicBranches = [
    Branch(
      id: 'branch',
      clinicId: 'clinic',
      name: 'Merkez',
      address: 'Adres',
      workingHours: WorkingHours.closed(),
    ),
    Branch(
      id: 'second',
      clinicId: 'clinic',
      name: 'Kadıköy',
      address: 'Adres',
      workingHours: WorkingHours.closed(),
    ),
  ];
  static const List<Department> catalogueDepartments = [
    Department(id: 'department', branchId: 'branch', name: 'Kardiyoloji'),
    Department(id: 'second-cardio', branchId: 'second', name: 'Kardiyoloji'),
    Department(id: 'radiology', branchId: 'branch', name: 'Radyoloji'),
  ];

  List<Staff> get records => [
    fixtures.doctor(id: 'ada', serviceIds: ['exam']),
    fixtures.doctor(
      id: 'ali',
      fullName: 'Ali Veli Demir',
      branchId: 'second',
      departmentId: 'second-cardio',
    ),
    fixtures.technician(
      id: 'ece',
      departmentId: 'radiology',
      serviceIds: ['radiology', 'lab'],
    ),
    fixtures.doctor(
      id: 'outside',
      fullName: 'Başka Kurum',
      branchId: 'other-clinic-branch',
    ),
  ];

  Future<void> initialize() async {
    repository.staffStream = staffStream.stream;
    branchRepository.branchesStream = branchStream.stream;
    departmentRepository.departmentsStream = Stream.multi((sink) {
      sink.add(const DataResult.success(data: catalogueDepartments));
      sink.close();
    });
    serviceRepository.servicesStream = Stream.multi((sink) {
      sink.add(DataResult.success(data: fixtures.services()));
      sink.close();
    });
    branches = BranchListCubit(WatchBranchesUseCase(branchRepository));
    await branches.watch('clinic');
    selection.selectClinic('clinic');
    selection.selectBranch('branch');
    AppDependency.injector.registerFactory<StaffListCubit>(() {
      staff = StaffListCubit(WatchStaffUseCase(repository));
      return staff;
    });
    AppDependency.injector.registerFactory<StaffDepartmentListCubit>(() {
      departments = StaffDepartmentListCubit(
        WatchDepartmentsOfBranchesUseCase(departmentRepository),
      );
      return departments;
    });
    AppDependency.injector.registerFactory<StaffServiceListCubit>(() {
      services = StaffServiceListCubit(
        WatchServicesOfBranchesUseCase(serviceRepository),
      );
      return services;
    });
    AppDependency.injector.registerFactory<StaffFilterCubit>(
      StaffFilterCubit.new,
    );
    AppDependency.injector.registerFactory<StaffEditorCubit>(
      StaffEditorCubit.new,
    );
    AppDependency.injector.registerFactory<StaffFormCubit>(
      () => StaffFormCubit(const FixedTemporaryPasswordGenerator()),
    );
    AppDependency.injector.registerFactory<StaffSaveCubit>(
      () => StaffSaveCubit(
        CreateStaffUseCase(FakeStaffAccountProvisioner(), repository),
        UpdateStaffUseCase(repository),
      ),
    );
    AppDependency.injector.registerFactory<DepartmentListCubit>(
      () => DepartmentListCubit(WatchDepartmentsUseCase(departmentRepository)),
    );
    AppDependency.injector.registerFactory<MedicalServiceListCubit>(
      () => MedicalServiceListCubit(
        WatchMedicalServicesUseCase(serviceRepository),
      ),
    );
  }

  /// Registers the additional admin shell factories for production router tests.
  void registerAdminScope() {
    final clinics = FakeClinicRepository()
      ..clinicsStream = Stream.value(
        const DataResult.success(
          data: [Clinic(id: 'clinic', name: 'Klinik')],
        ),
      );
    AppDependency.injector.registerFactory<ClinicListCubit>(
      () => ClinicListCubit(WatchClinicsUseCase(clinics)),
    );
    AppDependency.injector.registerFactory<BranchListCubit>(
      () => BranchListCubit(WatchBranchesUseCase(branchRepository)),
    );
  }

  Widget wrap(Widget child) {
    return InstitutionSelectionScope(
      selection: selection,
      child: BlocProvider<BranchListCubit>.value(
        value: branches,
        child: StaffManagementRouteScope(child: child),
      ),
    );
  }

  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    Size size = desktop,
    TextScaler? textScaler,
    bool dark = false,
  }) async {
    setSize(tester, size);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    await loadTestTranslations(
      tester,
      textScaler: textScaler,
      settle: false,
      theme: dark
          ? DarkTheme(screenSize).themeData
          : LightTheme(screenSize).themeData,
      child: wrap(child),
    );
  }

  Future<void> pumpRouter(
    WidgetTester tester,
    GoRouter router, {
    Size size = mobile,
  }) async {
    setSize(tester, size);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    await pumpLocalizedWidget(
      tester,
      LocalizationWrapper(
        child: Builder(
          builder: (context) {
            return BlocProvider(
              create: (_) => ThemeCubit(),
              child: MaterialApp.router(
                locale: context.locale,
                supportedLocales: context.supportedLocales,
                localizationsDelegates: context.localizationDelegates,
                theme: LightTheme(screenSize).themeData,
                routerConfig: router,
              ),
            );
          },
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));
  }

  void setSize(WidgetTester tester, Size size) {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Future<void> emitBranches(WidgetTester tester, [List<Branch>? value]) async {
    await tester.runAsync(() async {
      branchStream.add(DataResult.success(data: value ?? clinicBranches));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> emitStaff(
    WidgetTester tester,
    DataResult<List<Staff>> result,
  ) async {
    await tester.runAsync(() async {
      staffStream.add(result);
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pump(const Duration(milliseconds: 300));
  }

  Future<void> load(WidgetTester tester) async {
    await emitBranches(tester);
    await emitStaff(tester, DataResult.success(data: records));
  }

  Future<void> dispose(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    await branches.close();
    await staffStream.close();
    await branchStream.close();
    selection.dispose();
    await AppDependency.injector.reset();
  }
}
