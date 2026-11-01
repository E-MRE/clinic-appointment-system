import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/states/stream_watch_cubit.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';

/// Exposes the watch template through simple observable string states.
final class TestStreamWatchCubit
    extends StreamWatchCubit<String, String, String> {
  TestStreamWatchCubit(StreamUseCase<DataResult<String>, String> useCase)
    : super(useCase, 'loading');

  Future<void> watch(String params) => watchWith(params);

  @override
  String loadingState() => 'loading';

  @override
  String loadedState(String data) => 'loaded:$data';

  @override
  String failureState(Object? error) => 'failure:$error';
}
