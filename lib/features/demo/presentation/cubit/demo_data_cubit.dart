import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/usecases/clear_demo_data_use_case.dart';
import 'package:clinic_appointment_system/features/demo/domain/usecases/load_demo_data_use_case.dart';
import 'package:clinic_appointment_system/features/demo/presentation/cubit/demo_data_command.dart';
import 'package:clinic_appointment_system/features/demo/presentation/cubit/demo_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Runs the demo data command and exposes its progress and typed outcome.
final class DemoDataCubit extends Cubit<DemoDataState> {
  /// Injects the use cases that load or clear demo records.
  DemoDataCubit(this._loadDemoData, this._clearDemoData)
    : super(const DemoDataIdle());

  final LoadDemoDataUseCase _loadDemoData;
  final ClearDemoDataUseCase _clearDemoData;

  /// Loads the seed once at a time and publishes success or a typed failure.
  Future<void> load() {
    return _run(DemoDataCommand.load, () {
      return _loadDemoData.call(const NoParams());
    });
  }

  /// Clears demo records once at a time and publishes success or a failure.
  Future<void> clear() {
    return _run(DemoDataCommand.clear, () {
      return _clearDemoData.call(const NoParams());
    });
  }

  Future<void> _run(
    DemoDataCommand command,
    Future<DataResult<void>> Function() request,
  ) async {
    if (isClosed || state is DemoDataLoading) return;
    emit(DemoDataLoading(command));
    try {
      final result = await request();
      if (isClosed) return;
      if (result.isNotSuccess) {
        final errorCode = result.errorCode;
        emit(
          DemoDataFailure(
            errorCode is DemoErrorCode ? errorCode : DemoErrorCode.unavailable,
            command,
          ),
        );
        return;
      }
      emit(DemoDataSuccess(command));
    } on Exception {
      if (isClosed) return;
      emit(DemoDataFailure(DemoErrorCode.unavailable, command));
    }
  }
}
