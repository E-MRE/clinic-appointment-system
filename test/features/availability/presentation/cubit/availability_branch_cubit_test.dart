import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/states/watch_state.dart';
import 'package:clinic_appointment_system/features/availability/presentation/cubit/availability_branch_cubit.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branch_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../institution/domain/doubles/fake_branch_repository.dart';
import '../../domain/support/availability_fixture.dart';

void main() {
  const fixture = AvailabilityFixture();
  late FakeBranchRepository repository;
  late AvailabilityBranchCubit cubit;

  setUp(() {
    repository = FakeBranchRepository();
    cubit = AvailabilityBranchCubit(WatchBranchUseCase(repository));
    addTearDown(cubit.close);
  });

  test('watch loads authoritative branch with requested id', () async {
    final branch = Branch(
      id: 'branch',
      name: 'Central',
      clinicId: 'clinic',
      address: 'Main street',
      workingHours: fixture.hours,
    );
    repository.branchStream = Stream.value(DataResult.success(data: branch));
    expect(cubit.state, const WatchLoading<Branch, InstitutionErrorCode>());
    await cubit.watch('branch');
    await Future<void>.delayed(Duration.zero);
    expect(repository.watchedBranchId, 'branch');
    expect(cubit.state, WatchLoaded<Branch, InstitutionErrorCode>(branch));
  });

  test('maps institution code and falls back to unavailable', () async {
    final cases = <(Stream<DataResult<Branch>>, InstitutionErrorCode)>[
      (
        Stream.error(
          const InstitutionException(InstitutionErrorCode.invalidRecord),
        ),
        InstitutionErrorCode.invalidRecord,
      ),
      (Stream.error(StateError('provider')), InstitutionErrorCode.unavailable),
      (
        Stream.value(const DataResult.error()),
        InstitutionErrorCode.unavailable,
      ),
    ];
    for (final (stream, code) in cases) {
      repository.branchStream = stream;
      await cubit.watch('branch');
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, WatchFailure<Branch, InstitutionErrorCode>(code));
    }
  });
}
