import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/usecases/load_demo_data_use_case.dart';
import 'package:clinic_appointment_system/features/demo/presentation/cubit/demo_data_cubit.dart';
import 'package:clinic_appointment_system/features/demo/presentation/cubit/demo_data_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../domain/doubles/demo_use_case_fake_dependencies.dart';

void main() {
  const accounts = DemoAccounts(
    doctorUid: 'doctor-uid',
    doctorFullName: 'Dr. Servet',
    doctorEmail: 'servet@doktor.com',
    patientUid: 'patient-uid',
    patientFullName: 'Remzi Pala',
    patientEmail: 'remzi@pala.com',
  );

  test('emits idle, loading, and success in order', () async {
    final dependencies = DemoUseCaseFakeDependencies(
      accountResult: const DataResult.success(data: accounts),
    );
    final cubit = DemoDataCubit(
      LoadDemoDataUseCase(
        dependencies,
        dependencies,
        FixedClock(DateTime(2026, 11, 15)),
      ),
    );
    final states = <DemoDataState>[cubit.state];
    final subscription = cubit.stream.listen(states.add);

    await cubit.load();
    await Future<void>.delayed(Duration.zero);

    await subscription.cancel();
    expect(states, [
      isA<DemoDataIdle>(),
      isA<DemoDataLoading>(),
      isA<DemoDataSuccess>(),
    ]);
    await cubit.close();
  });

  test('emits the repository error code in the failure state', () async {
    final dependencies = DemoUseCaseFakeDependencies(
      accountResult: const DataResult.success(data: accounts),
      replaceResult: const DataResult.error(
        errorCode: DemoErrorCode.unavailable,
      ),
    );
    final cubit = DemoDataCubit(
      LoadDemoDataUseCase(
        dependencies,
        dependencies,
        FixedClock(DateTime(2026, 11, 15)),
      ),
    );
    final states = <DemoDataState>[cubit.state];
    final subscription = cubit.stream.listen(states.add);

    await cubit.load();
    await Future<void>.delayed(Duration.zero);

    await subscription.cancel();
    expect(states, [
      isA<DemoDataIdle>(),
      isA<DemoDataLoading>(),
      isA<DemoDataFailure>().having(
        (DemoDataFailure state) => state.errorCode,
        'errorCode',
        DemoErrorCode.unavailable,
      ),
    ]);
    await cubit.close();
  });
}
