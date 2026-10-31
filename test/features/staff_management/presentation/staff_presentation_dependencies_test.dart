import 'package:clinic_appointment_system/core/di/get_it/get_it_dependency_injection_manager.dart';
import 'package:clinic_appointment_system/core/di/injector/dependency_injector.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/cubit/medical_service_editor_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_department_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_editor_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_filter_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_form_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_save_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_service_list_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../data/doubles/staff_dependency_registrar.dart';

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
    'staff presentation and medical service editor resolve as screen-owned factories',
    () async {
      final pairs = <(Cubit<Object?>, Cubit<Object?>)>[
        (container.get<StaffListCubit>(), container.get<StaffListCubit>()),
        (
          container.get<StaffDepartmentListCubit>(),
          container.get<StaffDepartmentListCubit>(),
        ),
        (
          container.get<StaffServiceListCubit>(),
          container.get<StaffServiceListCubit>(),
        ),
        (container.get<StaffFilterCubit>(), container.get<StaffFilterCubit>()),
        (container.get<StaffFormCubit>(), container.get<StaffFormCubit>()),
        (container.get<StaffSaveCubit>(), container.get<StaffSaveCubit>()),
        (container.get<StaffEditorCubit>(), container.get<StaffEditorCubit>()),
        (
          container.get<MedicalServiceEditorCubit>(),
          container.get<MedicalServiceEditorCubit>(),
        ),
      ];
      for (final (first, second) in pairs) {
        expect(second, isNot(same(first)));
        await first.close();
        await second.close();
      }
    },
  );
}
