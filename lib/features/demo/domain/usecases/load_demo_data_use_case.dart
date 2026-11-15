import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/repositories/demo_account_resolver.dart';
import 'package:clinic_appointment_system/features/demo/domain/repositories/demo_data_repository.dart';
import 'package:clinic_appointment_system/features/demo/domain/services/demo_scenario_builder.dart';

/// Resolves the owner's accounts, builds the clock-relative scenario and
/// persists it through the demo data boundary.
final class LoadDemoDataUseCase implements UseCase<DataResult<void>, NoParams> {
  /// Injects the account resolver, replacement repository and scenario clock.
  const LoadDemoDataUseCase(this._accounts, this._repository, this._clock);

  final DemoAccountResolver _accounts;
  final DemoDataRepository _repository;
  final Clock _clock;

  @override
  Future<DataResult<void>> call(NoParams params) async {
    try {
      final accountResult = await _accounts.resolve();
      if (accountResult.isNotSuccess) {
        return DataResult.error(
          errorCode:
              accountResult.errorCode ?? DemoErrorCode.invalidAccountProfile,
        );
      }
      final accounts = accountResult.data;
      if (accounts == null) {
        return const DataResult.error(
          errorCode: DemoErrorCode.invalidAccountProfile,
        );
      }
      final dataSet = DemoScenarioBuilder(
        clock: _clock,
        accounts: accounts,
      ).build();
      return await _repository.replace(dataSet);
    } on ArgumentError {
      return const DataResult.error(errorCode: DemoErrorCode.invalidScenario);
    } on StateError {
      return const DataResult.error(errorCode: DemoErrorCode.invalidScenario);
    } on Exception {
      return const DataResult.error(errorCode: DemoErrorCode.invalidScenario);
    }
  }
}
