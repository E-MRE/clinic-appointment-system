import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/localization/localization_wrapper.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/loading/loading_state.dart';
import 'package:clinic_appointment_system/core/widgets/state/empty_state.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/create_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/update_medical_service_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_form_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_save_cubit.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/pages/medical_service_form_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../../support/localization_test_app.dart';
import '../../../institution/domain/doubles/fake_department_repository.dart';
import '../../domain/doubles/fake_medical_service_repository.dart';

void main() {
  late FakeDepartmentRepository departmentRepo;
  late FakeMedicalServiceRepository serviceRepo;
  late StreamController<DataResult<List<Department>>> departmentStream;
  late StreamController<DataResult<List<MedicalService>>> serviceStream;
  late DepartmentListCubit departmentListCubit;
  late MedicalServiceListCubit serviceListCubit;
  late InstitutionSelection selection;

  const departmentCardio = Department(
    id: 'dept-1',
    branchId: 'b-1',
    name: 'Kardiyoloji',
  );

  final sampleService = Examination(
    id: 's-123',
    name: 'Checkup',
    departmentId: 'dept-1',
    branchId: 'b-1',
    duration: ServiceDuration(20),
    fee: Money.kurus(80000),
  );

  setUp(() {
    departmentRepo = FakeDepartmentRepository();
    serviceRepo = FakeMedicalServiceRepository();
    departmentStream =
        StreamController<DataResult<List<Department>>>.broadcast();
    serviceStream =
        StreamController<DataResult<List<MedicalService>>>.broadcast();

    departmentRepo.departmentsStream = departmentStream.stream;
    serviceRepo.servicesStream = serviceStream.stream;

    departmentListCubit = DepartmentListCubit(
      WatchDepartmentsUseCase(departmentRepo),
    );
    serviceListCubit = MedicalServiceListCubit(
      WatchMedicalServicesUseCase(serviceRepo),
    );

    selection = InstitutionSelection();
    selection.selectClinic('c-1');
    selection.selectBranch('b-1');

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
    await serviceListCubit.close();
    await departmentStream.close();
    await serviceStream.close();
    selection.dispose();
    await AppDependency.injector.reset();
  });

  GoRouter createRouter({
    required Widget child,
    String initialLocation = '/form',
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        GoRoute(
          path: '/',
          builder: (_, _) => const Scaffold(body: Text('Home Page')),
        ),
        GoRoute(
          path: '/form',
          builder: (context, state) => InstitutionSelectionScope(
            selection: selection,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<DepartmentListCubit>.value(
                  value: departmentListCubit,
                ),
                BlocProvider<MedicalServiceListCubit>.value(
                  value: serviceListCubit,
                ),
              ],
              child: child,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> pumpRouter(WidgetTester tester, GoRouter router) async {
    await pumpLocalizedWidget(
      tester,
      LocalizationWrapper(
        child: Builder(
          builder: (context) {
            return MaterialApp.router(
              locale: context.locale,
              supportedLocales: context.supportedLocales,
              localizationsDelegates: context.localizationDelegates,
              theme: LightTheme(ScreenSize.mobile).themeData,
              routerConfig: router,
            );
          },
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('loading state shown while service list is fetching', (
    tester,
  ) async {
    await serviceListCubit.watch('b-1');

    final router = createRouter(
      child: const MedicalServiceFormPage(serviceId: 's-123'),
    );
    addTearDown(router.dispose);

    await pumpRouter(tester, router);

    expect(find.byType(LoadingState), findsOneWidget);
  });

  testWidgets('not-found empty state shown for unknown service id', (
    tester,
  ) async {
    await serviceListCubit.watch('b-1');

    final router = createRouter(
      child: const MedicalServiceFormPage(serviceId: 's-unknown'),
    );
    addTearDown(router.dispose);

    await pumpRouter(tester, router);

    await tester.runAsync(() async {
      serviceStream.add(const DataResult.success(data: <MedicalService>[]));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();

    expect(find.byType(EmptyState), findsOneWidget);
    expect(find.text('Hizmet bulunamadı'), findsOneWidget);
  });

  testWidgets('mobile page creates service and pops on save', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await departmentListCubit.watch('b-1');

    final router = createRouter(
      initialLocation: '/',
      child: const MedicalServiceFormPage(),
    );
    addTearDown(router.dispose);

    await pumpRouter(tester, router);
    unawaited(router.push('/form'));
    await tester.pump();

    await tester.runAsync(() async {
      departmentStream.add(const DataResult.success(data: [departmentCardio]));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();

    expect(find.text('Hizmet ekle'), findsOneWidget);

    // Fill form
    await tester.enterText(
      find.widgetWithText(TextFormField, '').first,
      'Cardio Consultation',
    );
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kardiyoloji').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, '5–240 dakika'),
      '20',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'KDV dahil'),
      '600',
    );

    serviceRepo.createResult = DataResult.success(data: sampleService);

    final saveButton = find.text('Hizmeti kaydet');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });

  testWidgets('mobile page edits service and pops on save', (tester) async {
    tester.view.physicalSize = const Size(800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await departmentListCubit.watch('b-1');
    await serviceListCubit.watch('b-1');

    final router = createRouter(
      initialLocation: '/',
      child: const MedicalServiceFormPage(serviceId: 's-123'),
    );
    addTearDown(router.dispose);

    await pumpRouter(tester, router);
    unawaited(router.push('/form'));
    await tester.pump();

    await tester.runAsync(() async {
      departmentStream.add(const DataResult.success(data: [departmentCardio]));
      serviceStream.add(DataResult.success(data: [sampleService]));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();

    expect(find.text('Hizmeti düzenle'), findsOneWidget);
    expect(find.text('Checkup'), findsOneWidget);

    serviceRepo.updateResult = DataResult.success(data: sampleService);

    final saveButton = find.text('Hizmeti kaydet');
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Home Page'), findsOneWidget);
  });
}
