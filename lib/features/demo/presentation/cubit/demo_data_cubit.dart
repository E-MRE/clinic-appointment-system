import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/features/demo/domain/enums/demo_error_code.dart';
import 'package:clinic_appointment_system/features/demo/domain/usecases/load_demo_data_use_case.dart';
import 'package:clinic_appointment_system/features/demo/presentation/cubit/demo_data_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Runs the demo data command and exposes its progress and typed outcome.
final class DemoDataCubit extends Cubit<DemoDataState> {
  /// Injects the use case that resolves accounts and replaces demo records.
  DemoDataCubit(this._loadDemoData) : super(const DemoDataIdle());

  final LoadDemoDataUseCase _loadDemoData;

  /// Loads the seed once at a time and publishes success or a typed failure.
  Future<void> load() async {
    if (isClosed || state is DemoDataLoading) return;
    emit(const DemoDataLoading());
    try {
      final result = await _loadDemoData.call(const NoParams());
      if (isClosed) return;
      if (result.isNotSuccess) {
        final errorCode = result.errorCode;
        emit(
          DemoDataFailure(
            errorCode is DemoErrorCode ? errorCode : DemoErrorCode.unavailable,
          ),
        );
        return;
      }
      emit(const DemoDataSuccess());
    } on Exception {
      if (isClosed) return;
      emit(const DemoDataFailure(DemoErrorCode.unavailable));
    }
  }
}
