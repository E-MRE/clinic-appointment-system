import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_catalog_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_catalog_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_catalog.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/patient_catalog_repositories.dart';
import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  late PatientCatalogRepositories repositories;
  late PatientCatalogCubit cubit;

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  Branch branch(String id, String clinicId) {
    return Branch(
      id: id,
      clinicId: clinicId,
      name: id,
      address: 'Adres',
      workingHours: WorkingHours.closed(),
    );
  }

  PatientCatalog loadedCatalog() {
    final state = cubit.state;
    if (state is! PatientCatalogLoaded) fail('Expected a loaded catalog.');
    return state.catalog;
  }

  setUp(() {
    repositories = PatientCatalogRepositories();
    cubit = PatientCatalogCubit(
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
    repositories.clinics.emit(catalogAllKey, [fixtures.clinic]);
    repositories.staff.emit(catalogAllKey, fixtures.staff);
    await flush();
    repositories.branches.emit('clinic', [fixtures.branch]);
    await flush();
    repositories.departments.emit('branch', fixtures.departments);
    repositories.services.emit('branch', fixtures.services);
    await flush();
  }

  test('follows clinic, branch, department and service chain', () async {
    cubit.watch();
    expect(cubit.state, isA<PatientCatalogLoading>());
    repositories.clinics.emit(catalogAllKey, [fixtures.clinic]);
    await flush();
    expect(repositories.branches.requested, ['clinic']);
    repositories.branches.emit('clinic', [fixtures.branch]);
    await flush();
    expect(repositories.departments.requested, ['branch']);
    expect(repositories.services.requested, ['branch']);
    repositories.departments.emit('branch', fixtures.departments);
    repositories.services.emit('branch', fixtures.services);
    await flush();
    expect(cubit.state, isA<PatientCatalogLoading>());
    repositories.staff.emit(catalogAllKey, fixtures.staff);
    await flush();
    final catalog = loadedCatalog();
    expect(catalog.branchById('branch')?.name, 'Merkez Şube');
    expect(catalog.departmentById('lab')?.name, 'Laboratuvar');
    expect(catalog.serviceById('xray')?.name, 'Akciğer Grafisi');
    expect(catalog.staffById('ayse')?.fullName, 'Dr. Ayşe Yılmaz');
  });

  test('re-subscribes dependents only when parent ids change', () async {
    await loadFixtures();
    repositories.branches.emit('clinic', [fixtures.branch]);
    await flush();
    expect(repositories.departments.requested, ['branch']);

    repositories.branches.emit('clinic', [
      fixtures.branch,
      branch('annex', 'clinic'),
    ]);
    await flush();
    expect(repositories.departments.requested, ['branch', 'annex,branch']);
    expect(repositories.services.requested, ['branch', 'annex,branch']);
    expect(repositories.departments.isWatched('branch'), isFalse);
    expect(repositories.departments.isWatched('annex,branch'), isTrue);

    repositories.clinics.emit(catalogAllKey, [
      fixtures.clinic,
      const Clinic(id: 'second', name: 'İkinci'),
    ]);
    await flush();
    expect(repositories.branches.requested, ['clinic', 'clinic', 'second']);
    expect(repositories.branches.isWatched('clinic'), isTrue);
    expect(repositories.branches.isWatched('second'), isTrue);
  });

  test('splits more branch ids than one query allows', () async {
    cubit.watch();
    repositories.clinics.emit(catalogAllKey, [fixtures.clinic]);
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
    repositories.clinics.emit(catalogAllKey, const []);
    repositories.staff.emit(catalogAllKey, const []);
    await flush();
    expect(loadedCatalog().services, isEmpty);
    expect(repositories.branches.requested, isEmpty);
    expect(repositories.departments.requested, isEmpty);
  });

  test('a failed result fails the catalog and cancels every watch', () async {
    await loadFixtures();
    repositories.staff.emitFailure(catalogAllKey);
    await flush();
    expect(cubit.state, isA<PatientCatalogFailure>());
    expect(repositories.clinics.isWatched(catalogAllKey), isFalse);
    expect(repositories.branches.isWatched('clinic'), isFalse);
    expect(repositories.services.isWatched('branch'), isFalse);
  });

  test('a stream error fails the catalog and watch restarts it', () async {
    await loadFixtures();
    repositories.departments.emitError('branch');
    await flush();
    expect(cubit.state, isA<PatientCatalogFailure>());

    await loadFixtures();
    expect(cubit.state, isA<PatientCatalogLoaded>());
  });

  test('a synchronous setup error fails the catalog', () async {
    repositories.staffSetupError = Exception('setup');
    cubit.watch();
    await flush();
    expect(cubit.state, isA<PatientCatalogFailure>());
  });

  test('close cancels every subscription', () async {
    await loadFixtures();
    await cubit.close();
    expect(repositories.clinics.isWatched(catalogAllKey), isFalse);
    expect(repositories.staff.isWatched(catalogAllKey), isFalse);
    expect(repositories.branches.isWatched('clinic'), isFalse);
    expect(repositories.departments.isWatched('branch'), isFalse);
    expect(repositories.services.isWatched('branch'), isFalse);
    cubit.watch();
    expect(cubit.isClosed, isTrue);
  });
}
