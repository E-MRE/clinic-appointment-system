import 'dart:async';

import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/checkbox_tile/app_checkbox_tile.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_segmented_control.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:clinic_appointment_system/core/widgets/text_field/app_text_field.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_medical_services_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/create_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/update_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_form_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_save_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/widgets/staff_form.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../../../institution/domain/doubles/fake_branch_repository.dart';
import '../../../institution/domain/doubles/fake_department_repository.dart';
import '../../../medical_services/domain/doubles/fake_medical_service_repository.dart';
import '../../domain/doubles/fake_staff_account_provisioner.dart';
import '../../domain/doubles/fake_staff_repository.dart';
import '../../domain/doubles/staff_fixtures.dart';
import 'doubles/pending_staff_repository.dart';
import 'doubles/sequence_temporary_password_generator.dart';

void main() {
  const fixtures = StaffFixtures();
  const department = Department(
    id: 'department',
    branchId: 'branch',
    name: 'Kardiyoloji',
  );
  const otherDepartment = Department(
    id: 'other-department',
    branchId: 'branch',
    name: 'Diğer bölüm',
  );
  final branch = Branch(
    id: 'branch',
    name: 'Merkez',
    clinicId: 'clinic',
    address: 'Adres',
    workingHours: WorkingHours.closed(),
  );
  final otherBranch = Branch(
    id: 'other-branch',
    name: 'İkinci şube',
    clinicId: 'clinic',
    address: 'Adres',
    workingHours: WorkingHours.closed(),
  );

  late FakeStaffRepository repository;
  late StaffRepository repositoryBoundary;
  late FakeStaffAccountProvisioner provisioner;
  late FakeBranchRepository branchRepository;
  late FakeDepartmentRepository departmentRepository;
  late FakeMedicalServiceRepository serviceRepository;
  late SequenceTemporaryPasswordGenerator generator;
  late BranchListCubit branchCubit;
  late StaffFormCubit formCubit;
  late StaffSaveCubit saveCubit;
  late DepartmentListCubit departmentCubit;
  late MedicalServiceListCubit serviceCubit;
  late StreamController<DataResult<List<Branch>>> branches;
  late StreamController<DataResult<List<Department>>> departments;
  late StreamController<DataResult<List<MedicalService>>> services;

  setUp(() async {
    repository = FakeStaffRepository();
    repositoryBoundary = repository;
    provisioner = FakeStaffAccountProvisioner();
    generator = SequenceTemporaryPasswordGenerator();
    branchRepository = FakeBranchRepository();
    departmentRepository = FakeDepartmentRepository();
    serviceRepository = FakeMedicalServiceRepository();
    branches = StreamController<DataResult<List<Branch>>>.broadcast();
    departments = StreamController<DataResult<List<Department>>>.broadcast();
    services = StreamController<DataResult<List<MedicalService>>>.broadcast();
    branchRepository.branchesStream = branches.stream;
    departmentRepository.departmentsStream = departments.stream;
    serviceRepository.servicesStream = services.stream;
    branchCubit = BranchListCubit(WatchBranchesUseCase(branchRepository));
    await branchCubit.watch('clinic');

    AppDependency.injector.registerFactory<StaffFormCubit>(() {
      formCubit = StaffFormCubit(generator);
      return formCubit;
    });
    AppDependency.injector.registerFactory<StaffSaveCubit>(() {
      saveCubit = StaffSaveCubit(
        CreateStaffUseCase(provisioner, repositoryBoundary),
        UpdateStaffUseCase(repositoryBoundary),
      );
      return saveCubit;
    });
    AppDependency.injector.registerFactory<DepartmentListCubit>(() {
      departmentCubit = DepartmentListCubit(
        WatchDepartmentsUseCase(departmentRepository),
      );
      return departmentCubit;
    });
    AppDependency.injector.registerFactory<MedicalServiceListCubit>(() {
      serviceCubit = MedicalServiceListCubit(
        WatchMedicalServicesUseCase(serviceRepository),
      );
      return serviceCubit;
    });
  });

  tearDown(() async {
    await branchCubit.close();
    await branches.close();
    await departments.close();
    await services.close();
    await AppDependency.injector.reset();
  });

  Finder field(String label) {
    return find.descendant(
      of: find.byWidgetPredicate(
        (widget) => widget is AppTextField && widget.label == label,
      ),
      matching: find.byType(TextFormField),
    );
  }

  Finder select(String label) {
    return find.byWidgetPredicate(
      (widget) => widget is AppSelectField<String> && widget.label == label,
    );
  }

  Future<void> emitLists(
    WidgetTester tester, {
    List<MedicalService>? catalogue,
  }) async {
    await tester.runAsync(() async {
      branches.add(DataResult.success(data: [branch, otherBranch]));
      departments.add(
        const DataResult.success(data: [department, otherDepartment]),
      );
      services.add(DataResult.success(data: catalogue ?? fixtures.services()));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  Future<void> pumpForm(
    WidgetTester tester, {
    Staff? staff,
    VoidCallback? onCancel,
    ValueChanged<Staff>? onSaved,
    Size size = const Size(1200, 1400),
    bool dark = false,
    TextScaler? textScaler,
  }) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final screenSize = BreakpointsConstants.resolve(size.width, size.height);
    ThemeData theme = LightTheme(screenSize).themeData;
    if (dark) theme = DarkTheme(screenSize).themeData;
    await loadTestTranslations(
      tester,
      theme: theme,
      textScaler: textScaler,
      child: BlocProvider<BranchListCubit>.value(
        value: branchCubit,
        child: Material(
          child: SingleChildScrollView(
            child: StaffForm(
              staff: staff,
              onCancel: onCancel,
              onSaved: onSaved,
            ),
          ),
        ),
      ),
    );
    await emitLists(tester);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
    });
  }

  Future<void> choose(WidgetTester tester, String label, String option) async {
    final dropdown = find.descendant(
      of: select(label),
      matching: find.byType(DropdownButtonFormField<String>),
    );
    await tester.ensureVisible(dropdown);
    await tester.tap(dropdown);
    await tester.pumpAndSettle();
    await tester.tap(find.text(option).last);
    await tester.pumpAndSettle();
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
  }

  Future<void> choosePlacement(WidgetTester tester) async {
    await choose(tester, 'Şube', 'Merkez');
    await emitLists(tester);
    await choose(tester, 'Bölüm', 'Kardiyoloji');
  }

  Future<void> fillIdentity(WidgetTester tester) async {
    await tester.enterText(field('Ad soyad'), '  Deniz Kaya  ');
    await tester.enterText(field('Uzmanlık'), '  Kardiyoloji  ');
    await tester.enterText(field('E-posta'), 'deniz@klinik.com');
  }

  Future<void> submit(WidgetTester tester, {bool editing = false}) async {
    String label = 'Hesabı oluştur';
    if (editing) label = 'Kaydet';
    await tester.ensureVisible(find.text(label));
    await tester.tap(find.text(label));
    await tester.pumpAndSettle();
  }

  testWidgets(
    'creates a password and regenerates it without losing typed fields',
    (tester) async {
      await pumpForm(tester);
      expect(find.text('Generated-1-Aa9'), findsOneWidget);
      expect(find.text('Vazgeç'), findsNothing);
      await tester.enterText(field('Ad soyad'), 'Deniz Kaya');
      await tester.enterText(field('Geçici şifre'), 'Typed-password');
      await tester.tap(find.byTooltip('Yeni şifre üret'));
      await tester.pumpAndSettle();
      expect(find.text('Generated-2-Aa9'), findsOneWidget);
      expect(find.text('Deniz Kaya'), findsOneWidget);
      expect(formCubit.state.password, 'Generated-2-Aa9');
    },
  );

  testWidgets(
    'switches specialty through the role strategy and restores its draft',
    (tester) async {
      await pumpForm(tester);
      await tester.enterText(field('Uzmanlık'), 'Kardiyoloji');
      await tester.tap(find.text('Teknisyen'));
      await tester.pumpAndSettle();
      expect(field('Uzmanlık'), findsNothing);
      await tester.tap(find.text('Doktor'));
      await tester.pumpAndSettle();
      expect(field('Uzmanlık'), findsOneWidget);
      expect(find.text('Kardiyoloji'), findsOneWidget);
    },
  );

  testWidgets(
    'filters service kinds, branch and department and clears old assignments',
    (tester) async {
      await pumpForm(tester);
      await choosePlacement(tester);
      final foreign = fixtures
          .services(branchId: 'other-branch')
          .first
          .withId('foreign-branch');
      final wrongDepartment = fixtures
          .services(departmentId: 'other-department')
          .first
          .withId('foreign-department');
      await emitLists(
        tester,
        catalogue: [...fixtures.services(), foreign, wrongDepartment],
      );
      expect(find.text('Verdiği hizmetler · Kardiyoloji'), findsOneWidget);
      expect(find.text('Consultation · 30 dk'), findsOneWidget);
      expect(find.byType(AppCheckboxTile), findsOneWidget);
      await tester.tap(find.text('Consultation · 30 dk'));
      await tester.pumpAndSettle();
      expect(formCubit.state.serviceIds, ['exam']);
      await tester.ensureVisible(find.text('Teknisyen'));
      await tester.tap(find.text('Teknisyen'));
      await tester.pumpAndSettle();
      expect(formCubit.state.serviceIds, isEmpty);
      expect(find.text('Consultation · 30 dk'), findsNothing);
      expect(find.text('X-ray · 15 dk'), findsOneWidget);
      expect(find.text('Blood count · 10 dk'), findsOneWidget);
      expect(find.byType(AppCheckboxTile), findsNWidgets(2));
      await tester.tap(find.text('X-ray · 15 dk'));
      await tester.pumpAndSettle();
      await choose(tester, 'Bölüm', 'Diğer bölüm');
      expect(formCubit.state.serviceIds, isEmpty);
      // Only the foreign-department examination exists, which technicians cannot provide.
      expect(find.text('Bu bölümde verilebilecek hizmet yok'), findsOneWidget);
      await choose(tester, 'Şube', 'İkinci şube');
      expect(departmentRepository.watchedBranchId, 'other-branch');
      expect(serviceRepository.watchedBranchId, 'other-branch');
      expect(formCubit.state.departmentId, isEmpty);
      expect(find.byType(AppCheckboxTile), findsNothing);
    },
  );

  testWidgets('shows the empty eligible message for an empty catalogue', (
    tester,
  ) async {
    await pumpForm(tester);
    await choosePlacement(tester);
    await emitLists(tester, catalogue: []);
    expect(find.text('Bu bölümde verilebilecek hizmet yok'), findsOneWidget);
    expect(find.byType(AppCheckboxTile), findsNothing);
  });

  testWidgets(
    'localized field errors block invalid identity, password and placement',
    (tester) async {
      await pumpForm(tester);
      await tester.enterText(field('Ad soyad'), ' \t');
      await tester.enterText(field('Uzmanlık'), ' ');
      await tester.enterText(field('E-posta'), 'invalid');
      await tester.enterText(field('Geçici şifre'), 'short');
      await submit(tester);
      expect(find.text('Personelin adını ve soyadını girin.'), findsOneWidget);
      expect(find.text('Doktorun uzmanlık alanını girin.'), findsOneWidget);
      expect(find.text('Geçerli bir e-posta adresi girin.'), findsOneWidget);
      expect(find.text('Şifreniz en az 8 karakter olmalıdır.'), findsOneWidget);
      expect(find.text('Bir şube seçin.'), findsOneWidget);
      expect(find.text('Bir bölüm seçin.'), findsOneWidget);
      expect(provisioner.provisionCalls, 0);
      expect(repository.createCalls, 0);
    },
  );

  testWidgets(
    'creates with typed values and exact edited password then resets all fields',
    (tester) async {
      Staff? saved;
      await pumpForm(tester, onSaved: (staff) => saved = staff);
      await choosePlacement(tester);
      await fillIdentity(tester);
      await tester.enterText(field('Geçici şifre'), '  Exact-Pass-9  ');
      await tester.ensureVisible(find.text('Consultation · 30 dk'));
      await tester.tap(find.text('Consultation · 30 dk'));
      await submit(tester);
      expect(provisioner.provisionCalls, 1);
      expect(provisioner.receivedCredentials?.email, 'deniz@klinik.com');
      expect(provisioner.receivedCredentials?.password, '  Exact-Pass-9  ');
      expect(repository.createdStaff?.fullName, 'Deniz Kaya');
      expect(
        repository.createdStaff,
        isA<Doctor>().having(
          (staff) => staff.specialty,
          'specialty',
          'Kardiyoloji',
        ),
      );
      expect(repository.createdStaff?.branchId, 'branch');
      expect(repository.createdStaff?.departmentId, 'department');
      expect(repository.createdStaff?.serviceIds, ['exam']);
      expect(saved?.id, 'new-uid');
      expect(find.text('Generated-2-Aa9'), findsOneWidget);
      expect(
        tester.widget<TextFormField>(field('Ad soyad')).initialValue,
        isEmpty,
      );
      expect(
        tester.widget<TextFormField>(field('Uzmanlık')).initialValue,
        isEmpty,
      );
      expect(
        tester.widget<TextFormField>(field('E-posta')).initialValue,
        isEmpty,
      );
      expect(formCubit.state.branchId, isEmpty);
      expect(formCubit.state.departmentId, isEmpty);
      expect(formCubit.state.serviceIds, isEmpty);
      expect(departmentCubit.state, isA<InstitutionListLoading<Department>>());
      expect(serviceCubit.state, isA<InstitutionListLoading<MedicalService>>());
      expect(departments.hasListener, isFalse);
      expect(services.hasListener, isFalse);
    },
  );

  testWidgets(
    'creates technicians without specialty using radiology and lab assignments',
    (tester) async {
      await pumpForm(tester);
      await tester.tap(find.text('Teknisyen'));
      await tester.pumpAndSettle();
      await choosePlacement(tester);
      await tester.enterText(field('Ad soyad'), 'Ece Kaya');
      await tester.enterText(field('E-posta'), 'ece@klinik.com');
      await tester.tap(find.text('X-ray · 15 dk'));
      await tester.tap(find.text('Blood count · 10 dk'));
      await submit(tester);
      expect(repository.createdStaff?.role, UserRole.technician);
      expect(repository.createdStaff?.serviceIds, ['radiology', 'lab']);
      expect(provisioner.receivedCredentials?.password, 'Generated-1-Aa9');
    },
  );

  testWidgets(
    'shows localized emailAlreadyInUse and preserves the draft for retry',
    (tester) async {
      provisioner.creationException = const AuthException(
        AuthErrorCode.emailAlreadyInUse,
      );
      await pumpForm(tester);
      await choosePlacement(tester);
      await fillIdentity(tester);
      await submit(tester);
      expect(
        find.text(
          'Bu e-posta adresiyle bir hesap zaten var. Giriş yapabilir veya şifrenizi sıfırlayabilirsiniz.',
        ),
        findsOneWidget,
      );
      expect(find.text('Generated-1-Aa9'), findsOneWidget);
      expect(formCubit.state.fullName, '  Deniz Kaya  ');
      expect(repository.createCalls, 0);
      provisioner.creationException = null;
      await submit(tester);
      expect(repository.createCalls, 1);
      expect(
        find.text(
          'Bu e-posta adresiyle bir hesap zaten var. Giriş yapabilir veya şifrenizi sıfırlayabilirsiniz.',
        ),
        findsNothing,
      );
    },
  );

  testWidgets(
    'explains an orphaned account and asks the admin to contact support',
    (tester) async {
      repository.createException = const UserException(
        UserErrorCode.unavailable,
      );
      provisioner.deleteFails = true;
      await pumpForm(tester);
      await choosePlacement(tester);
      await fillIdentity(tester);
      await submit(tester);
      expect(
        find.text(
          'Hesap oluşturuldu ancak personel profili kaydedilemedi ve hesap silinemedi. Yeniden hesap oluşturmayın; destek ekibiyle iletişime geçin.',
        ),
        findsOneWidget,
      );
      expect(generator.calls, 1);
      expect(formCubit.state.email, 'deniz@klinik.com');
    },
  );

  testWidgets(
    'edit locks account and placement, hides password and updates editable fields',
    (tester) async {
      final original = fixtures.doctor(id: 'existing', serviceIds: ['exam']);
      Staff? saved;
      await pumpForm(
        tester,
        staff: original,
        onSaved: (staff) => saved = staff,
      );
      expect(tester.widget<TextFormField>(field('E-posta')).enabled, isFalse);
      expect(
        tester.widget<AppSelectField<String>>(select('Şube')).enabled,
        isFalse,
      );
      expect(
        tester.widget<AppSelectField<String>>(select('Bölüm')).enabled,
        isFalse,
      );
      expect(
        tester
            .widget<AppSegmentedControl<UserRole>>(
              find.byType(AppSegmentedControl<UserRole>),
            )
            .enabled,
        isFalse,
      );
      expect(field('Geçici şifre'), findsNothing);
      expect(find.byTooltip('Yeni şifre üret'), findsNothing);
      expect(
        find.text(
          'Geçici şifreyi personelle paylaşın. Hesap açıldıktan sonra kendi oturumunuz açık kalır.',
        ),
        findsNothing,
      );
      expect(
        tester.widget<AppCheckboxTile>(find.byType(AppCheckboxTile)).value,
        isTrue,
      );
      expect(generator.calls, 0);
      await tester.enterText(field('Ad soyad'), 'Edited Name');
      await tester.enterText(field('Uzmanlık'), 'Edited Specialty');
      await tester.tap(find.text('Consultation · 30 dk'));
      await submit(tester, editing: true);
      expect(repository.updateCalls, 1);
      expect(provisioner.provisionCalls, 0);
      expect(repository.updatedStaff?.id, original.id);
      expect(repository.updatedStaff?.email, original.email);
      expect(repository.updatedStaff?.branchId, original.branchId);
      expect(repository.updatedStaff?.departmentId, original.departmentId);
      expect(repository.updatedStaff?.role, original.role);
      expect(repository.updatedStaff?.fullName, 'Edited Name');
      expect(
        repository.updatedStaff,
        isA<Doctor>().having(
          (staff) => staff.specialty,
          'specialty',
          'Edited Specialty',
        ),
      );
      expect(repository.updatedStaff?.serviceIds, isEmpty);
      expect(saved?.id, 'existing');
      expect(find.text('Edited Name'), findsOneWidget);
      expect(generator.calls, 0);
    },
  );

  testWidgets('cancel invokes the supplied callback', (tester) async {
    int calls = 0;
    await pumpForm(tester, onCancel: () => calls++);
    await tester.ensureVisible(find.text('Vazgeç'));
    await tester.tap(find.text('Vazgeç'));
    expect(calls, 1);
    expect(provisioner.provisionCalls, 0);
  });

  testWidgets(
    'save progress disables both actions until the request completes',
    (tester) async {
      final pending = PendingStaffRepository(repository);
      repositoryBoundary = pending;
      int cancelled = 0;
      await pumpForm(tester, onCancel: () => cancelled++);
      await choosePlacement(tester);
      await fillIdentity(tester);
      await tester.ensureVisible(find.text('Hesabı oluştur'));
      await tester.tap(find.text('Hesabı oluştur'));
      await tester.pump();
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      expect(
        tester.widget<TextButton>(find.byType(TextButton)).onPressed,
        isNull,
      );
      await tester.tap(find.text('Vazgeç'));
      expect(cancelled, 0);
      pending.completion.complete();
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(repository.createCalls, 1);
    },
  );

  testWidgets('provider ownership closes all four form cubits on removal', (
    tester,
  ) async {
    await pumpForm(tester);
    await choosePlacement(tester);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();
    expect(formCubit.isClosed, isTrue);
    expect(saveCubit.isClosed, isTrue);
    expect(departmentCubit.isClosed, isTrue);
    expect(serviceCubit.isClosed, isTrue);
    expect(departments.hasListener, isFalse);
    expect(services.hasListener, isFalse);
    expect(branchCubit.isClosed, isFalse);
  });

  for (final size in [
    const Size(390, 844),
    const Size(700, 1200),
    const Size(1200, 1400),
  ]) {
    testWidgets(
      'placement follows responsive layout at width ${size.width} with large dark text',
      (tester) async {
        await pumpForm(
          tester,
          size: size,
          dark: true,
          textScaler: const TextScaler.linear(1.4),
          onCancel: () {},
        );
        final branchPosition = tester.getTopLeft(select('Şube'));
        final departmentPosition = tester.getTopLeft(select('Bölüm'));
        if (size.width < 600) {
          expect(departmentPosition.dy, greaterThan(branchPosition.dy));
          expect(departmentPosition.dx, branchPosition.dx);
        } else {
          expect(departmentPosition.dy, branchPosition.dy);
          expect(departmentPosition.dx, greaterThan(branchPosition.dx));
        }
        final namePosition = tester.getTopLeft(field('Ad soyad'));
        final specialtyPosition = tester.getTopLeft(field('Uzmanlık'));
        final emailPosition = tester.getTopLeft(field('E-posta'));
        expect(specialtyPosition.dy, greaterThan(namePosition.dy));
        expect(emailPosition.dy, greaterThan(specialtyPosition.dy));
        expect(tester.takeException(), isNull);
      },
    );
  }
}
