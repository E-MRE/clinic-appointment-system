import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/usecases/watch_services_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_service_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../medical_services/domain/doubles/fake_medical_service_repository.dart';
import '../../domain/doubles/staff_fixtures.dart';

void main() {
  test(
    'watch forwards branch ids and emits loaded records, then replaces selection',
    () async {
      final repository = FakeMedicalServiceRepository();
      final sample = const StaffFixtures().services().first;
      repository.servicesStream = Stream.value(
        DataResult.success(data: [sample]),
      ).asBroadcastStream();
      final cubit = StaffServiceListCubit(
        WatchServicesOfBranchesUseCase(repository),
      );
      addTearDown(cubit.close);
      const branchIds = ['first', 'second'];
      await cubit.watch(branchIds);
      await Future<void>.delayed(Duration.zero);
      expect(repository.watchedBranchIds, branchIds);
      expect(
        cubit.state,
        isA<InstitutionListLoaded<MedicalService>>().having(
          (state) => state.items,
          'items',
          [sample],
        ),
      );
      await cubit.watch(['replacement']);
      expect(repository.watchedBranchIds, ['replacement']);
      await cubit.watch([]);
      expect(repository.watchedBranchIds, isEmpty);
    },
  );
}
