import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/repositories/demo_data_repository.dart';

/// Removes demo-marked records without resolving or changing login accounts.
final class ClearDemoDataUseCase
    implements UseCase<DataResult<void>, NoParams> {
  /// Injects the repository that owns demo record deletion.
  const ClearDemoDataUseCase(this._repository);

  final DemoDataRepository _repository;

  @override
  Future<DataResult<void>> call(NoParams params) async {
    try {
      return await _repository.clear();
    } on Exception {
      return const DataResult.error(errorCode: DemoErrorCode.invalidScenario);
    }
  }
}
