import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_department_list_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/services/staff_availability_subtitle_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../institution/domain/doubles/fake_department_repository.dart';
import '../../domain/doubles/staff_fixtures.dart';

void main() {
  test(
    'watch forwards branch ids and emits loaded records, then replaces selection',
    () async {
      final repository = FakeDepartmentRepository();
      const sample = Department(
        id: 'department',
        name: 'Cardiology',
        branchId: 'first',
      );
      repository.departmentsStream = Stream.value(
        const DataResult.success(data: [sample]),
      ).asBroadcastStream();
      final cubit = StaffDepartmentListCubit(
        WatchDepartmentsOfBranchesUseCase(repository),
        const StaffAvailabilitySubtitleFormatter(),
      );
      addTearDown(cubit.close);
      const branchIds = ['first', 'second'];
      await cubit.watch(branchIds);
      await Future<void>.delayed(Duration.zero);
      expect(repository.watchedBranchIds, branchIds);
      expect(
        cubit.state,
        isA<InstitutionListLoaded<Department>>().having(
          (state) => state.items,
          'items',
          [sample],
        ),
      );
      expect(
        cubit.subtitleFor(
          const StaffFixtures().doctor(
            id: 'doctor',
            fullName: 'Ada Kaya',
            departmentId: 'department',
          ),
          roleLabel: 'Doktor',
        ),
        'Ada Kaya · Doktor · Cardiology',
      );
      await cubit.watch(['replacement']);
      expect(repository.watchedBranchIds, ['replacement']);
      await cubit.watch([]);
      expect(repository.watchedBranchIds, isEmpty);
    },
  );
}
