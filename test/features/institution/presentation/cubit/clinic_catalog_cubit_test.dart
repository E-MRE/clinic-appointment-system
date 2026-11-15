import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_catalog_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/clinic_catalog_repositories.dart';

void main() {
  const clinic = Clinic(id: 'clinic', name: 'Clinic');
  late ClinicCatalogRepositories repositories;
  late ClinicCatalogCubit cubit;

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  Branch branch(String id, String clinicId, {String? name}) {
    return Branch(
      id: id,
      clinicId: clinicId,
      name: name ?? id,
      address: 'Address',
      workingHours: WorkingHours.closed(),
    );
  }

  List<Department> departments() => const [
    Department(id: 'department', name: 'Cardiology', branchId: 'branch'),
  ];

  List<MedicalService> services() => [
    Examination(
      id: 'service',
      name: 'Cardiology Exam',
      departmentId: 'department',
      branchId: 'branch',
      duration: ServiceDuration(20),
      fee: Money.minorUnits(120000),
    ),
  ];

  List<Staff> staff() => const [
    Doctor(
      id: 'doctor',
      fullName: 'Dr. Ayşe Yılmaz',
      email: 'doctor@test',
      branchId: 'branch',
      departmentId: 'department',
      serviceIds: ['service'],
      specialty: 'Cardiology',
    ),
  ];

  ClinicCatalog loadedCatalog() {
    final state = cubit.state;
    if (state is! ClinicCatalogLoaded) fail('Expected a loaded catalog.');
    return state.catalog;
  }

  setUp(() {
    repositories = ClinicCatalogRepositories();
    cubit = ClinicCatalogCubit(
      WatchClinicsUseCase(repositories),
      WatchBranchesUseCase(repositories),
      WatchDepartmentsOfBranchesUseCase(repositories),
      WatchServicesOfBranchesUseCase(repositories),
      WatchStaffUseCase(repositories),
    );
  });

  tearDown(() async {
    await cubit.close();
    await repositories.close();
  });

  Future<void> loadFixtures() async {
    cubit.watch();
    repositories.clinics.emit(clinicCatalogAllKey, const [clinic]);
    repositories.staff.emit(clinicCatalogAllKey, staff());
    await flush();
    repositories.branches.emit('clinic', [
      branch('branch', 'clinic', name: 'Central Branch'),
    ]);
    await flush();
    repositories.departments.emit('branch', departments());
    repositories.services.emit('branch', services());
    await flush();
  }

  test('follows clinic, branch, department and service chain', () async {
    cubit.watch();
    expect(cubit.state, isA<ClinicCatalogLoading>());
    repositories.clinics.emit(clinicCatalogAllKey, const [clinic]);
    await flush();
    expect(repositories.branches.requested, ['clinic']);
    repositories.branches.emit('clinic', [
      branch('branch', 'clinic', name: 'Central Branch'),
    ]);
    await flush();
    expect(repositories.departments.requested, ['branch']);
    expect(repositories.services.requested, ['branch']);
    repositories.departments.emit('branch', departments());
    repositories.services.emit('branch', services());
    await flush();
    expect(cubit.state, isA<ClinicCatalogLoading>());
    repositories.staff.emit(clinicCatalogAllKey, staff());
    await flush();
    final catalog = loadedCatalog();
    expect(catalog.clinicById('clinic')?.name, 'Clinic');
    expect(catalog.branchById('branch')?.name, 'Central Branch');
    expect(catalog.departmentById('department')?.name, 'Cardiology');
    expect(catalog.serviceById('service')?.name, 'Cardiology Exam');
    expect(catalog.staffById('doctor')?.fullName, 'Dr. Ayşe Yılmaz');
  });

  test('updates clinic snapshots without replacing branch watches', () async {
    await loadFixtures();
    repositories.clinics.emit(clinicCatalogAllKey, const [
      Clinic(id: 'clinic', name: 'Renamed Clinic'),
    ]);
    await flush();

    expect(loadedCatalog().clinics.single.name, 'Renamed Clinic');
    expect(repositories.branches.requested, ['clinic']);
  });

  test('re-subscribes dependents only when parent ids change', () async {
    await loadFixtures();
    repositories.branches.emit('clinic', [
      branch('branch', 'clinic', name: 'Central Branch'),
    ]);
    await flush();
    expect(repositories.departments.requested, ['branch']);

    repositories.branches.emit('clinic', [
      branch('branch', 'clinic', name: 'Central Branch'),
      branch('annex', 'clinic'),
    ]);
    await flush();
    expect(repositories.departments.requested, ['branch', 'annex,branch']);
    expect(repositories.services.requested, ['branch', 'annex,branch']);
    expect(repositories.departments.isWatched('branch'), isFalse);
    expect(repositories.departments.isWatched('annex,branch'), isTrue);

    repositories.clinics.emit(clinicCatalogAllKey, const [
      clinic,
      Clinic(id: 'second', name: 'Second Clinic'),
    ]);
    await flush();
    expect(repositories.branches.requested, ['clinic', 'clinic', 'second']);
    expect(repositories.branches.isWatched('clinic'), isTrue);
    expect(repositories.branches.isWatched('second'), isTrue);
  });

  test('splits more branch ids than one query allows', () async {
    cubit.watch();
    repositories.clinics.emit(clinicCatalogAllKey, const [clinic]);
    await flush();
    final ids = [for (int index = 10; index < 41; index++) 'b$index'];
    repositories.branches.emit('clinic', [
      for (final id in ids) branch(id, 'clinic'),
    ]);
    await flush();
    expect(repositories.departments.requested, [
      ids.take(30).join(','),
      ids.skip(30).join(','),
    ]);
  });

  test('no clinics loads an empty catalog without dependent queries', () async {
    cubit.watch();
    repositories.clinics.emit(clinicCatalogAllKey, const []);
    repositories.staff.emit(clinicCatalogAllKey, const []);
    await flush();
    expect(loadedCatalog().clinics, isEmpty);
    expect(loadedCatalog().services, isEmpty);
    expect(repositories.branches.requested, isEmpty);
    expect(repositories.departments.requested, isEmpty);
  });

  test('a failed result fails the catalog and cancels every watch', () async {
    await loadFixtures();
    repositories.staff.emitFailure(clinicCatalogAllKey);
    await flush();
    expect(cubit.state, isA<ClinicCatalogFailure>());
    expect(repositories.clinics.isWatched(clinicCatalogAllKey), isFalse);
    expect(repositories.branches.isWatched('clinic'), isFalse);
    expect(repositories.services.isWatched('branch'), isFalse);
  });

  test('a stream error fails the catalog and watch restarts it', () async {
    await loadFixtures();
    repositories.departments.emitError('branch');
    await flush();
    expect(cubit.state, isA<ClinicCatalogFailure>());

    await loadFixtures();
    expect(cubit.state, isA<ClinicCatalogLoaded>());
  });

  test('a synchronous setup error fails the catalog', () async {
    repositories.staffSetupError = Exception('setup');
    cubit.watch();
    await flush();
    expect(cubit.state, isA<ClinicCatalogFailure>());
  });

  test('close cancels every subscription', () async {
    await loadFixtures();
    await cubit.close();
    expect(repositories.clinics.isWatched(clinicCatalogAllKey), isFalse);
    expect(repositories.staff.isWatched(clinicCatalogAllKey), isFalse);
    expect(repositories.branches.isWatched('clinic'), isFalse);
    expect(repositories.departments.isWatched('branch'), isFalse);
    expect(repositories.services.isWatched('branch'), isFalse);
    cubit.watch();
    expect(cubit.isClosed, isTrue);
  });
}
