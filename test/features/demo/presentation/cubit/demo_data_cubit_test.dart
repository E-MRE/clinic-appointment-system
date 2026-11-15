import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/models/demo_accounts.dart';
import 'package:clinic_appointment_system/features/demo/domain/usecases/clear_demo_data_use_case.dart';
import 'package:clinic_appointment_system/features/demo/domain/usecases/load_demo_data_use_case.dart';
import 'package:clinic_appointment_system/features/demo/presentation/cubit/demo_data_command.dart';
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

  DemoDataCubit createCubit(DemoUseCaseFakeDependencies dependencies) {
    return DemoDataCubit(
      LoadDemoDataUseCase(
        dependencies,
        dependencies,
        FixedClock(DateTime(2026, 11, 15)),
      ),
      ClearDemoDataUseCase(dependencies),
    );
  }

  test('emits load command, loading, and success in order', () async {
    final dependencies = DemoUseCaseFakeDependencies(
      accountResult: const DataResult.success(data: accounts),
    );
    final cubit = createCubit(dependencies);
    final states = <DemoDataState>[cubit.state];
    final subscription = cubit.stream.listen(states.add);

    await cubit.load();
    await Future<void>.delayed(Duration.zero);

    await subscription.cancel();
    expect(states, [
      isA<DemoDataIdle>(),
      isA<DemoDataLoading>().having(
        (DemoDataLoading state) => state.command,
        'command',
        DemoDataCommand.load,
      ),
      isA<DemoDataSuccess>().having(
        (DemoDataSuccess state) => state.command,
        'command',
        DemoDataCommand.load,
      ),
    ]);
    await cubit.close();
  });

  test('emits clear command, loading, and success in order', () async {
    final dependencies = DemoUseCaseFakeDependencies(
      accountResult: const DataResult.success(data: accounts),
    );
    final cubit = createCubit(dependencies);
    final states = <DemoDataState>[cubit.state];
    final subscription = cubit.stream.listen(states.add);

    await cubit.clear();
    await Future<void>.delayed(Duration.zero);

    await subscription.cancel();
    expect(states, [
      isA<DemoDataIdle>(),
      isA<DemoDataLoading>().having(
        (DemoDataLoading state) => state.command,
        'command',
        DemoDataCommand.clear,
      ),
      isA<DemoDataSuccess>().having(
        (DemoDataSuccess state) => state.command,
        'command',
        DemoDataCommand.clear,
      ),
    ]);
    expect(dependencies.resolveCalls, 0);
    expect(dependencies.clearCalls, 1);
    await cubit.close();
  });

  test('emits the clear repository error code and command', () async {
    final dependencies = DemoUseCaseFakeDependencies(
      accountResult: const DataResult.success(data: accounts),
      clearResult: const DataResult.error(errorCode: DemoErrorCode.unavailable),
    );
    final cubit = createCubit(dependencies);
    final states = <DemoDataState>[cubit.state];
    final subscription = cubit.stream.listen(states.add);

    await cubit.clear();
    await Future<void>.delayed(Duration.zero);

    await subscription.cancel();
    expect(states, [
      isA<DemoDataIdle>(),
      isA<DemoDataLoading>().having(
        (DemoDataLoading state) => state.command,
        'command',
        DemoDataCommand.clear,
      ),
      isA<DemoDataFailure>()
          .having(
            (DemoDataFailure state) => state.errorCode,
            'errorCode',
            DemoErrorCode.unavailable,
          )
          .having(
            (DemoDataFailure state) => state.command,
            'command',
            DemoDataCommand.clear,
          ),
    ]);
    await cubit.close();
  });

  test('ignores a load request while clear is running', () async {
    final clearResult = Completer<DataResult<void>>();
    final dependencies = DemoUseCaseFakeDependencies(
      accountResult: const DataResult.success(data: accounts),
      clearOperation: () {
        return clearResult.future;
      },
    );
    final cubit = createCubit(dependencies);

    final clearRequest = cubit.clear();
    await cubit.load();

    expect(cubit.state, isA<DemoDataLoading>());
    expect(dependencies.clearCalls, 1);
    expect(dependencies.resolveCalls, 0);

    clearResult.complete(const DataResult.success(data: null));
    await clearRequest;
    expect(
      cubit.state,
      isA<DemoDataSuccess>().having(
        (DemoDataSuccess state) => state.command,
        'command',
        DemoDataCommand.clear,
      ),
    );
    await cubit.close();
  });
}
