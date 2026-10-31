import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/watch_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_list_cubit.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/doubles/staff_fixtures.dart';
import '../doubles/mock_staff_repository.dart';

void main() {
  test(
    'watch observes all staff and retry re-subscribes with NoParams',
    () async {
      const fixtures = StaffFixtures();
      final staff = <Staff>[fixtures.doctor(), fixtures.technician()];
      final repository = MockStaffRepository();
      when(
        repository.watchStaff,
      ).thenAnswer((_) => Stream.value(DataResult.success(data: staff)));
      final cubit = StaffListCubit(WatchStaffUseCase(repository));
      addTearDown(cubit.close);
      expect(cubit.state, isA<InstitutionListLoading<Staff>>());
      await cubit.watch();
      await Future<void>.delayed(Duration.zero);
      expect(
        cubit.state,
        isA<InstitutionListLoaded<Staff>>().having(
          (state) => state.items,
          'items',
          staff,
        ),
      );
      await cubit.retry();
      await Future<void>.delayed(Duration.zero);
      const expectedWatches = 2;
      verify(repository.watchStaff).called(expectedWatches);
    },
  );

  test('UserException stream and setup errors map to unavailable', () async {
    final repository = MockStaffRepository();
    when(repository.watchStaff).thenAnswer(
      (_) => Stream.error(const UserException(UserErrorCode.invalidProfile)),
    );
    final cubit = StaffListCubit(WatchStaffUseCase(repository));
    addTearDown(cubit.close);
    await cubit.watch();
    await Future<void>.delayed(Duration.zero);
    expect(
      cubit.state,
      isA<InstitutionListFailure<Staff>>().having(
        (state) => state.code,
        'code',
        InstitutionErrorCode.unavailable,
      ),
    );
    when(
      repository.watchStaff,
    ).thenThrow(const UserException(UserErrorCode.unavailable));
    await cubit.watch();
    expect(
      cubit.state,
      isA<InstitutionListFailure<Staff>>().having(
        (state) => state.code,
        'code',
        InstitutionErrorCode.unavailable,
      ),
    );
  });
}
