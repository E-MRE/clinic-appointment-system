import 'package:clinic_appointment_system/core/di/get_it/get_it_dependency_injection_manager.dart';
import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/data/models/staff_model_factory.dart';
import 'package:clinic_appointment_system/features/staff_management/data/repositories/firestore_staff_repository.dart';
import 'package:clinic_appointment_system/features/staff_management/data/services/firebase_secondary_auth_provider.dart';
import 'package:clinic_appointment_system/features/staff_management/data/services/firebase_staff_account_provisioner.dart';
import 'package:clinic_appointment_system/features/staff_management/data/services/secondary_auth_provider.dart';
import 'package:clinic_appointment_system/features/staff_management/data/services/secure_temporary_password_generator.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/repositories/staff_repository.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/services/staff_account_provisioner.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/services/temporary_password_generator.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/create_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/update_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'doubles/staff_dependency_registrar.dart';

void main() {
  late DependencyInjector container;
  setUp(() async {
    container = GetItDependencyInjectionManager().injector;
    await container.reset();
    StaffDependencyRegistrar().registerDependencies(container);
    await container.unregister<FirebaseFirestore>();
    container.registerSingleton<FirebaseFirestore>(FakeFirebaseFirestore());
  });
  tearDown(() => container.reset());

  test(
    'staff graph resolves as lazy singletons without initializing Firebase Auth',
    () {
      expect(container.get<StaffRepository>(), isA<FirestoreStaffRepository>());
      expect(
        container.get<StaffAccountProvisioner>(),
        isA<FirebaseStaffAccountProvisioner>(),
      );
      expect(
        container.get<SecondaryAuthProvider>(),
        isA<FirebaseSecondaryAuthProvider>(),
      );
      expect(
        container.get<TemporaryPasswordGenerator>(),
        isA<SecureTemporaryPasswordGenerator>(),
      );
      final List<(Object, Object)> pairs = [
        (
          container.get<StaffModelFactory>(),
          container.get<StaffModelFactory>(),
        ),
        (container.get<StaffRepository>(), container.get<StaffRepository>()),
        (
          container.get<SecondaryAuthProvider>(),
          container.get<SecondaryAuthProvider>(),
        ),
        (
          container.get<StaffAccountProvisioner>(),
          container.get<StaffAccountProvisioner>(),
        ),
        (
          container.get<TemporaryPasswordGenerator>(),
          container.get<TemporaryPasswordGenerator>(),
        ),
        (
          container.get<CreateStaffUseCase>(),
          container.get<CreateStaffUseCase>(),
        ),
        (
          container.get<UpdateStaffUseCase>(),
          container.get<UpdateStaffUseCase>(),
        ),
        (
          container.get<WatchStaffUseCase>(),
          container.get<WatchStaffUseCase>(),
        ),
        (
          container.get<WatchDepartmentsOfBranchesUseCase>(),
          container.get<WatchDepartmentsOfBranchesUseCase>(),
        ),
        (
          container.get<WatchServicesOfBranchesUseCase>(),
          container.get<WatchServicesOfBranchesUseCase>(),
        ),
      ];
      for (final (Object first, Object second) in pairs) {
        expect(second, same(first));
      }
    },
  );
}
